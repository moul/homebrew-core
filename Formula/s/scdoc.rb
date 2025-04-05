class Scdoc < Formula
  desc "Small man page generator"
  homepage "https://sr.ht/~sircmpwn/scdoc/"
  url "https://git.sr.ht/~sircmpwn/scdoc/archive/1.11.3.tar.gz"
  sha256 "4c5c6136540384e5455b250f768e7ca11b03fdba1a8efc2341ee0f1111e57612"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8800df45f7cd670d5638e4acd2fad0905fdae6f5216b71bd6d897fcda12c4cd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6eeed5394fb071aa14153ebe3cb3eb2edb4458c1b25d91adf6a32116fe1eb16b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb0a27fea684b0a8caa7aa98c64df84c9db68c7003fffd827055449bbff373e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3206d11b5d62c3cee98c1cb2f0da0e6674261f4dccd22f7e8f833685c6c53112"
    sha256 cellar: :any_skip_relocation, sonoma:         "4546aace4ad6725de9e7e788533896a8600cc99495de6c86cca71b8fc8038dda"
    sha256 cellar: :any_skip_relocation, ventura:        "01fcd247b749191d4d6154498b0d324d856a8da745f3571b643ddebe18919bc6"
    sha256 cellar: :any_skip_relocation, monterey:       "f5c4019c594ac3e10d08e1a7f44a560d16e661a33051e0bca823521937b2e691"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "998b1d189ac54d1f50be511cc66479fb7cecb219870200ce3d9f5a17db47b48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e73b822f530807cec33251c40cf375923318cbb1b889f8f494afc33ae34cc932"
  end

  def install
    # scdoc sets by default LDFLAGS=-static which doesn't work on macos(x)
    system "make", "LDFLAGS=", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    preamble = <<~EOF
      .\\" Generated by scdoc #{version}
      .\\" Complete documentation for this program is not available as a GNU info page
      .ie \\n(.g .ds Aq \\(aq
      .el       .ds Aq '
      .nh
      .ad l
      .\\" Begin generated content:
    EOF
    assert_equal preamble, shell_output("#{bin}/scdoc </dev/null")
  end
end
