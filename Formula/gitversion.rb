class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.5.tar.gz"
  sha256 "d9fe27a78fa67ec57501ba5c4d79540a0673ab9fcf959cee1f1ac4d3ff8d51cd"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "cb6164f3b238ed42388693615168e0fea56d945166da0912d9f7a3264df4b3ac"
    sha256 cellar: :any, catalina: "29858e20f50cea39a42f8314357945d05e558ca7166324a2e7e608ce069727a4"
    sha256 cellar: :any, mojave:   "0c0ebeeb392a191a18807997f9cd811fb96f3433fd65b595ccd324621c88dd2b"
  end

  depends_on "dotnet"

  def install
    system "dotnet", "build",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", "out",
           "src/GitVersion.App/GitVersion.App.csproj"

    libexec.install Dir["out/*"]

    (bin/"gitversion").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/gitversion.dll" "$@"
    EOS
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["GITHUB_ACTIONS"] = nil

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "config", "user.name", "Test"
    system "git", "config", "user.email", "test@example.com"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--message='Test'"
    assert_match '"FullSemVer": "0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
