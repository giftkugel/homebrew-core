class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.9.2.tar.gz"
  sha256 "771c85fe44ad6e89a457e72d399f81146e48d2abb8ac555653bf4cb49941aa42"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39386f933ad62a80123f1767f668c5f94f4afcc2826910dd7de79245e8f452bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39386f933ad62a80123f1767f668c5f94f4afcc2826910dd7de79245e8f452bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39386f933ad62a80123f1767f668c5f94f4afcc2826910dd7de79245e8f452bf"
    sha256 cellar: :any_skip_relocation, ventura:        "0b06c449fac9c63d4175106b458c67891f8d1585bfcf3a2df5590ba85508be9b"
    sha256 cellar: :any_skip_relocation, monterey:       "0b06c449fac9c63d4175106b458c67891f8d1585bfcf3a2df5590ba85508be9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b06c449fac9c63d4175106b458c67891f8d1585bfcf3a2df5590ba85508be9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44914d16d4d9402027c92d9fc15cf320ca7bcb2ef5eb4d8ae4ea181f59b18474"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://example.com/",
                 shell_output("#{bin}/muffet https://example.com 2>&1", 1)
  end
end
