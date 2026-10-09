# typed: strict
# frozen_string_literal: true

require "minitest/autorun"
# Needed when run outside Homebrew (brew style already loads Pathname).
require "pathname" # rubocop:disable Lint/RedundantRequireStatement
require "tmpdir"
load File.expand_path("../bin/update-macos-timber", __dir__)

# Tests macos-timber cask updates from a GitHub release tag.
class UpdateTimberTest < Minitest::Test
  TAG = "v0.5.0"
  VERSION = "0.5.0"
  SHA256 = "a" * 64
  DOWNLOAD_URL = "https://github.com/nnutter/macos-timber/releases/download/v0.5.0/Timber.zip"

  def test_updates_version_and_sha256_from_release_tag
    with_cask do |cask_path|
      downloader = FakeDownloader.new(SHA256)
      committer = RecordingCommitter.new

      updater = TimberCaskUpdater::Updater.new(
        cask_path:  cask_path,
        downloader: downloader,
        committer:  committer,
      )
      updater.update(TAG)

      assert_equal expected_cask, cask_path.read
      assert_equal [DOWNLOAD_URL], downloader.urls
      assert_equal [{ package: "macos-timber", version: TAG }], committer.commits
    end
  end

  def test_rejects_tag_without_v_prefix
    with_cask do |cask_path|
      original_contents = cask_path.read
      committer = RecordingCommitter.new
      updater = updater_for(cask_path, committer:)

      assert_raises(TimberCaskUpdater::UpdateError) { updater.update("0.5.0") }
      assert_equal original_contents, cask_path.read
      assert_empty committer.commits
    end
  end

  def test_rejects_invalid_release_tag
    with_cask do |cask_path|
      original_contents = cask_path.read
      committer = RecordingCommitter.new
      updater = updater_for(cask_path, committer:)

      assert_raises(TimberCaskUpdater::UpdateError) { updater.update("v0.5.0/extra") }
      assert_equal original_contents, cask_path.read
      assert_empty committer.commits
    end
  end

  def test_does_not_change_cask_when_file_is_missing
    Dir.mktmpdir do |directory|
      cask_path = Pathname(directory).join("macos-timber.rb")
      committer = RecordingCommitter.new
      updater = updater_for(cask_path, committer:)

      assert_raises(TimberCaskUpdater::UpdateError) { updater.update(TAG) }
      refute_predicate cask_path, :exist?
      assert_empty committer.commits
    end
  end

  def test_commits_updated_cask_with_package_and_version_message
    with_git_repository do |repository_root|
      cask_directory = repository_root.join("Casks")
      cask_directory.mkpath
      cask_path = cask_directory.join("macos-timber.rb")
      cask_path.write(original_cask)
      git(repository_root, "add", cask_path.to_s)
      git(repository_root, "commit", "-m", "Add macos-timber cask")

      updater = TimberCaskUpdater::Updater.new(
        cask_path:  cask_path,
        downloader: FakeDownloader.new(SHA256),
      )
      updater.update(TAG)

      log_message = git_output(repository_root, "log", "-1", "--pretty=%s")
      assert_equal "Updated macos-timber to #{TAG}", log_message
      assert_equal expected_cask, cask_path.read
    end
  end

  private

  def updater_for(cask_path, committer:)
    TimberCaskUpdater::Updater.new(
      cask_path:  cask_path,
      downloader: FakeDownloader.new(SHA256),
      committer:  committer,
    )
  end

  def with_cask
    Dir.mktmpdir do |directory|
      cask_path = Pathname(directory).join("macos-timber.rb")
      cask_path.write(original_cask)
      yield cask_path
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

  def original_cask
    <<~CASK
      cask "macos-timber" do
        version "0.4.0"
        sha256 "#{"b" * 64}"

        url "https://github.com/nnutter/macos-timber/releases/download/v\#{version}/Timber.zip"
        name "Timber"
      end
    CASK
  end

  def expected_cask
    <<~CASK
      cask "macos-timber" do
        version "#{VERSION}"
        sha256 "#{SHA256}"

        url "https://github.com/nnutter/macos-timber/releases/download/v\#{version}/Timber.zip"
        name "Timber"
      end
    CASK
  end

  # Supplies a fixed digest so tests do not access the network.
  class FakeDownloader
    attr_reader :urls

    def initialize(sha256)
      @sha256 = sha256
      @urls = []
    end

    def sha256(url)
      @urls << url
      @sha256
    end
  end

  # Records commit requests instead of touching git.
  class RecordingCommitter
    attr_reader :commits

    def initialize
      @commits = []
    end

    def commit(cask, version:)
      @commits << { package: cask.package_name, version: version }
    end
  end
end
