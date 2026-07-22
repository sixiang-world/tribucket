class CorrettoJdk17 < Formula
  desc "Amazon Corretto JDK 17 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "17.0.19.10.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-macos-jdk.tar.gz"
      sha256 "786a9bbb94d2d077ca5618a80eec4c1a909595fbe24b617d57f50d360f96990e"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-macos-jdk.tar.gz"
      sha256 "36b2e4f270e8b70aafe8c1ec8c254cc323675fd911d1d3f49981e3f18f73e638"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-linux-jdk.tar.gz"
      sha256 "7e3f37d58e39f5879e3c10412177b75ccbf85b54b267b1c06d7da19a28cf9cfc"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz"
      sha256 "89b50d4ef5d27ce1f8e5cad616525e14f7665b7b4a1ffca85381b0e21401034f"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
