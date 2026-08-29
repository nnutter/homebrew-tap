# nnutter/homebrew-tap

Personal Homebrew tap.

## Enable tap

```bash
brew tap nnutter/tap
```

## Install a formula from a private repository

The `gcloud-tunnel`, `slush`, and `timber` formulas download source from private GitHub repositories.
Give Homebrew a GitHub token that has read access to the repository:

```bash
export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"
brew install nnutter/tap/timber
```

Tap workflows mint an installation token from the GitHub App below.
Install the app on the private formula repositories and store `APP_CLIENT_ID`
and `APP_PRIVATE_KEY` on this tap.

## Update a formula release

Give the formula name and the GitHub release tag.
The script downloads the release, calculates its SHA-256, updates the formula, and commits the change.
For a private repository, set `HOMEBREW_GITHUB_API_TOKEN` as shown above first.

```bash
mise run update -- timber v0.5
```

The commit message looks like `Updated timber to v0.5`.

## Open a pull request from an upstream repository

An upstream repository can open a pull request on this tap.
The repository can do this after it publishes a release.
Copy `examples/update-homebrew-formula.yml` to `.github/workflows/update-homebrew-formula.yml` in the upstream repository.
Set `FORMULA_NAME` to the formula file name in this tap.

The default `GITHUB_TOKEN` cannot write to another repository.
Use a GitHub App.
GitHub recommends a GitHub App when a workflow needs another repository.

### Create the GitHub App

1. Open [GitHub Apps](https://github.com/settings/apps) for the account that owns this tap.
2. Select **New GitHub App**.
3. Give the app a name, for example `homebrew-tap-formula-updates`.
4. Set **Homepage URL** to the tap URL: `https://github.com/nnutter/homebrew-tap`.
5. Clear **Webhook** / **Active**.
   This app does not receive webhook events.
6. Under **Repository permissions**, set:
   - **Contents**: Read and write
   - **Pull requests**: Read and write
   - **Metadata**: Read-only
7. Under **Where can this GitHub App be installed?**, select **Only on this account**.
8. Select **Create GitHub App**.
9. Copy the **Client ID**.
   The Client ID is not the App ID.
10. Under **Private keys**, select **Generate a private key**.
    Keep the downloaded `.pem` file.

### Install the app

1. Open the app settings.
2. Select **Install App**.
3. Install the app on the account that owns this tap.
4. Select **Only select repositories**.
5. Grant access to `homebrew-tap` and to each private formula repository
   (`gcloud-tunnel`, `slush`, `timber`, and any later private formulas).

Tap CI needs Contents access to those private repositories so it can download
release archives. Upstream formula-update workflows need Contents and Pull
requests access to this tap.

### Store credentials

In this tap and in each upstream repository, open **Settings** > **Secrets and variables** > **Actions**.

1. Create a repository variable named `APP_CLIENT_ID`.
   Paste the Client ID.
2. Create a repository secret named `APP_PRIVATE_KEY`.
   Paste the full contents of the `.pem` file.
   Include the `BEGIN` and `END` lines.

The tap workflows and the example upstream workflow read those names.

CAUTION: Store the private key only in repositories that you trust.
The key can write to this tap.

If this tap uses branch rules, allow the app to create `formula-updates/*` branches.

### What the workflow does

The workflow runs when the upstream repository publishes a release.
You can also start the workflow and give a tag.

1. The workflow creates an installation access token for this tap.
2. The workflow checks out this tap.
3. The workflow runs `bin/update-formula FORMULA TAG`.
4. The workflow pushes a branch and opens a pull request.

The pull request title looks like `Updated timber to v0.5`.
The tap `brew test-bot` workflow then tests the pull request.

See [authenticated API requests with a GitHub App in a GitHub Actions workflow](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/making-authenticated-api-requests-with-a-github-app-in-a-github-actions-workflow).
