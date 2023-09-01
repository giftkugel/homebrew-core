class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/refs/tags/23.03.tar.gz"
  sha256 "5cf1e4a410b92e920be7802ea2de59882395d529029fae2144bb72ed78aaca91"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  # Upstream creates stable version tags (e.g., `23.03`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  # https://github.com/porjo/youtubeuploader/issues/169
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07b89e4ed8ee773dde84b81772471e48ee910d291989d577136c0368cc34f67f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07b89e4ed8ee773dde84b81772471e48ee910d291989d577136c0368cc34f67f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07b89e4ed8ee773dde84b81772471e48ee910d291989d577136c0368cc34f67f"
    sha256 cellar: :any_skip_relocation, ventura:        "a24e908a50675105dd26c9392e9f02f639555c1f00588e450646159279b234c0"
    sha256 cellar: :any_skip_relocation, monterey:       "a24e908a50675105dd26c9392e9f02f639555c1f00588e450646159279b234c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a24e908a50675105dd26c9392e9f02f639555c1f00588e450646159279b234c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdb69cdbb2b5e68d63cc9a4234b01cf2ee89f2d2da18a4df1c5b28268e46e29e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -X main.appVersion=#{version}")
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}/youtubeuploader -version")

    # OAuth
    (testpath/"client_secrets.json").write <<~EOS
      {
        "installed": {
          "client_id": "foo_client_id",
          "client_secret": "foo_client_secret",
          "redirect_uris": [
            "http://localhost:8080/oauth2callback",
            "https://localhost:8080/oauth2callback"
           ],
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://accounts.google.com/o/oauth2/token"
        }
      }
    EOS

    (testpath/"request.token").write <<~EOS
      {
        "access_token": "test",
        "token_type": "Bearer",
        "refresh_token": "test",
        "expiry": "2020-01-01T00:00:00.000000+00:00"
      }
    EOS

    output = shell_output("#{bin}/youtubeuploader -filename #{test_fixtures("test.m4a")} 2>&1", 1)
    assert_match 'oauth2: "invalid_client" "The OAuth client was not found."', output
  end
end
