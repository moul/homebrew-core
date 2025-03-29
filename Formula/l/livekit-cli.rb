class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "50ace1d37d6ffd80dd186dc685a43812f85a0bbdd6b006327dbf26b802a04958"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9972c74ffe760430e50c2759add0bb94613a5c47ee89386ec7618c62dc7a9d17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9972c74ffe760430e50c2759add0bb94613a5c47ee89386ec7618c62dc7a9d17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9972c74ffe760430e50c2759add0bb94613a5c47ee89386ec7618c62dc7a9d17"
    sha256 cellar: :any_skip_relocation, sonoma:        "aea5731ed3b8fb3f81c2d1087faef212c5bc03b87232f35b6ca6d116fce52560"
    sha256 cellar: :any_skip_relocation, ventura:       "aea5731ed3b8fb3f81c2d1087faef212c5bc03b87232f35b6ca6d116fce52560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a33313e892580b61adab9b324aeb7b89a39d73f229c3b25cd80f56acdb0257a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
