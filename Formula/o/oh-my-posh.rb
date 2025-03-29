class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.7.0.tar.gz"
  sha256 "552de694f7b308be94c52da4e79373f644b3212b77342000af32eeeb60dc3e21"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d70eb6d05d2ec91b54ff7292979d707660d8829fcf7bb7ca9efe542d8d173aa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6211014d1650da3cd000fee7a2f0b71294756c7aa375b6e3da68cef00f7d1c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5eedf11666d0fe2e5940aea1b5193195cd0f1d31b7f963d1465fa86e5535e4dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6637d69e51a17939ba88778af5e0261bd3409ae974963fb8d6dc4a1e8fd7fc39"
    sha256 cellar: :any_skip_relocation, ventura:       "c649ced58f981615d39fe99e23dd4d47675f9631086833fd1b944bc90c785426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b38bf1fbae24231f54d7c073dbeb376f969f5df05f8845f1933e87ef0b2824f1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
