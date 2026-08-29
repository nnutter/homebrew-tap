# typed: strict
# frozen_string_literal: true

require "minitest/autorun"
# Needed when run outside Homebrew (brew style already loads Pathname).
require "pathname" # rubocop:disable Lint/RedundantRequireStatement
require "tmpdir"
load File.expand_path("../bin/update-formula", __dir__)

# Tests formula updates from a formula name and GitHub release tag.
class UpdateFormulaTest < Minitest::Test
  ARCHIVE_URL = "https://github.com/nnutter/git-wt/archive/refs/tags/v0.5.tar.gz"
  SHA256 = "a" * 64

  def test_updates_named_formula_url_and_sha256
    with_formula_directory do |formula_directory|
      write_formula(formula_directory, "git-wt", "nnutter/git-wt")
      committer = RecordingCommitter.new

      updater = FormulaReleaseUpdater::FormulaUpdater.new(
        formula_directory: formula_directory,
        downloader:        FakeDownloader.new(SHA256),
        committer:         committer,
      )
      updater.update("git-wt", "v0.5")

      assert_equal expected_formula, File.read(formula_directory.join("git-wt.rb"))
      assert_equal [{ package: "git-wt", version: "v0.5" }], committer.commits
    end
  end

  def test_updates_authenticated_archive_url_and_preserves_user
    authenticated_user = %Q(user: "x-access-token:\#{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN")}")

    with_formula_directory do |formula_directory|
      formula_path = formula_directory.join("git-wt.rb")
      formula_path.write(<<~FORMULA)
        class GitWt < Formula
          url "https://github.com/nnutter/git-wt/archive/refs/tags/v0.4.tar.gz",
              #{authenticated_user}
          sha256 "#{"b" * 64}"
        end
      FORMULA

      updater = FormulaReleaseUpdater::FormulaUpdater.new(
        formula_directory: formula_directory,
        downloader:        FakeDownloader.new(SHA256),
        committer:         RecordingCommitter.new,
      )
      updater.update("git-wt", "v0.5")

      assert_includes formula_path.read,
                      "url \"https://api.github.com/repos/nnutter/git-wt/tarball/v0.5\","
      assert_includes formula_path.read, authenticated_user
      assert_includes formula_path.read, "sha256 \"#{SHA256}\""
    end
  end

  def test_authenticates_github_archive_downloads
    request = FormulaReleaseUpdater::ArchiveDownloader.new(github_token: "secret").send(
      :request_for,
      URI(ARCHIVE_URL),
    )

    assert_equal "Bearer secret", request["Authorization"]
  end

  def test_authenticates_github_api_tarball_downloads
    request = FormulaReleaseUpdater::ArchiveDownloader.new(github_token: "secret").send(
      :request_for,
      URI("https://api.github.com/repos/nnutter/git-wt/tarball/v0.5"),
    )

    assert_equal "Bearer secret", request["Authorization"]
  end

  def test_does_not_send_github_token_to_redirect_hosts
    request = FormulaReleaseUpdater::ArchiveDownloader.new(github_token: "secret").send(
      :request_for,
      URI("https://codeload.github.com/nnutter/git-wt/tar.gz/refs/tags/v0.5"),
    )

    assert_nil request["Authorization"]
  end

  def test_builds_archive_url_from_formula_repository
    with_formula_directory do |formula_directory|
      write_formula(formula_directory, "espanso", "espanso/espanso")
      committer = RecordingCommitter.new

      updater = FormulaReleaseUpdater::FormulaUpdater.new(
        formula_directory: formula_directory,
        downloader:        FakeDownloader.new(SHA256),
        committer:         committer,
      )
      updater.update("espanso", "v2.4.0")

      assert_includes(
        File.read(formula_directory.join("espanso.rb")),
        'url "https://github.com/espanso/espanso/archive/refs/tags/v2.4.0.tar.gz"',
      )
      assert_equal [{ package: "espanso", version: "v2.4.0" }], committer.commits
    end
  end

  def test_does_not_change_formula_when_name_is_unknown
    with_formula_directory do |formula_directory|
      formula_path = write_formula(formula_directory, "other", "nnutter/other")
      committer = RecordingCommitter.new

      updater = FormulaReleaseUpdater::FormulaUpdater.new(
        formula_directory: formula_directory,
        downloader:        FakeDownloader.new(SHA256),
        committer:         committer,
      )

      assert_raises(FormulaReleaseUpdater::FormulaUpdateError) { updater.update("git-wt", "v0.5") }
      assert_equal original_formula("nnutter/other"), File.read(formula_path)
      assert_empty committer.commits
    end
  end

  def test_rejects_formula_without_github_tag_archive
    with_formula_directory do |formula_directory|
      formula_path = formula_directory.join("magnitude.rb")
      formula_path.write(<<~FORMULA)
        class Magnitude < Formula
          url "https://registry.npmjs.org/@magnitudedev/cli/-/cli-0.0.1.tgz"
          sha256 "#{"b" * 64}"
        end
      FORMULA
      committer = RecordingCommitter.new
      original_contents = formula_path.read

      updater = FormulaReleaseUpdater::FormulaUpdater.new(
        formula_directory: formula_directory,
        downloader:        FakeDownloader.new(SHA256),
        committer:         committer,
      )

      assert_raises(FormulaReleaseUpdater::FormulaUpdateError) { updater.update("magnitude", "v1.0") }
      assert_equal original_contents, formula_path.read
      assert_empty committer.commits
    end
  end

  def test_rejects_invalid_release_tag
    with_formula_directory do |formula_directory|
      write_formula(formula_directory, "git-wt", "nnutter/git-wt")

      updater = FormulaReleaseUpdater::FormulaUpdater.new(
        formula_directory: formula_directory,
        downloader:        FakeDownloader.new(SHA256),
        committer:         RecordingCommitter.new,
      )

      assert_raises(FormulaReleaseUpdater::FormulaUpdateError) { updater.update("git-wt", "v0.5/extra") }
    end
  end

  def test_commits_updated_formula_with_package_and_version_message
    with_git_repository do |repository_root|
      formula_directory = repository_root.join("Formula")
      formula_directory.mkpath
      formula_path = write_formula(formula_directory, "git-wt", "nnutter/git-wt")
      git(repository_root, "add", formula_path.to_s)
      git(repository_root, "commit", "-m", "Add git-wt formula")

      updater = FormulaReleaseUpdater::FormulaUpdater.new(
        formula_directory: formula_directory,
        downloader:        FakeDownloader.new(SHA256),
      )
      updater.update("git-wt", "v0.5")

      log_message = git_output(repository_root, "log", "-1", "--pretty=%s")
      assert_equal "Updated git-wt to v0.5", log_message
      assert_equal expected_formula, formula_path.read
    end
  end

  private

  def with_formula_directory
    Dir.mktmpdir do |directory|
      formula_directory = Pathname(directory)
      yield formula_directory
    end
  end

  def with_git_repository
    Dir.mktmpdir do |directory|
      repository_root = Pathname(directory)
      git(repository_root, "init")
      git(repository_root, "config", "user.email", "test@example.com")
      git(repository_root, "config", "user.name", "Test User")
      yield repository_root
    end
  end

  def git(repository_root, *arguments)
    system("git", "-C", repository_root.to_s, *arguments, exception: true)
  end

  def git_output(repository_root, *arguments)
    IO.popen(["git", "-C", repository_root.to_s, *arguments], &:read).strip
  end

  def write_formula(formula_directory, name, repository)
    path = formula_directory.join("#{name}.rb")
    path.write(original_formula(repository))
    path
  end

  def original_formula(repository = "nnutter/git-wt")
    <<~FORMULA
      class GitWt < Formula
        url "https://github.com/#{repository}/archive/refs/tags/v0.4.tar.gz"
        sha256 "#{"b" * 64}"
      end
    FORMULA
  end

  def expected_formula
    <<~FORMULA
      class GitWt < Formula
        url "#{ARCHIVE_URL}"
        sha256 "#{SHA256}"
      end
    FORMULA
  end

  # Supplies a fixed digest so tests do not access the network.
  class FakeDownloader
    def initialize(sha256)
      @sha256 = sha256
    end

    def sha256(_url)
      @sha256
    end
  end

  # Records commit requests instead of touching git.
  class RecordingCommitter
    attr_reader :commits

    def initialize
      @commits = []
    end

    def commit(formula, version:)
      @commits << { package: formula.package_name, version: version }
    end
  end
end
