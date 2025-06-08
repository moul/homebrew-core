class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.25.28.tar.gz"
  sha256 "8c5d2963c40013007f8936c12331afbd38befd7b2c54986629cc47021d65284d"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0010a615c779365c01f381b4d3e3589b60fa3305a83cfe54379a32f1f0c76cf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eece37504ea2e0c4fcf57c277934494991ddeb710bd425a9035f4719ad814228"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "537879681a0399d1fb8ff9c261e87e2e0f62b193e741799a76c64c339fd221a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9726d2c6b1bab7bf0beb919d514183bd5f6e0f5ae780ed382b16515f80874075"
    sha256 cellar: :any_skip_relocation, ventura:       "a2ae1ed5ad789f3b47c43c540769d369110a8d702b0bad423dde2fbf911b1025"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9bbd27357d048df4050f2075d4f5fc24af14845d091ccfe7ebc9f03949cc07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7102fc621958ae4a0270b7acc5ad118b234cea2ee8c21ef2b5130cd4dd8339c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}/sqruff rules")

    (testpath/"test.sql").write <<~EOS
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    EOS

    output = shell_output("#{bin}/sqruff lint --format human #{testpath}/test.sql 2>&1")
    assert_match "All Finished", output
  end
end
