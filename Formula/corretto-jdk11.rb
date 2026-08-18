class CorrettoJdk11 < Formula
  desc "Amazon Corretto JDK 11 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "11.0.31.11.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-aarch64-macos-jdk.tar.gz"
      sha256 "878b362d1942a4e4e553f1237ca3534a88b246dc200bbb13f2dc1712fb5602f4"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-macos-jdk.tar.gz"
      sha256 "b2dc525aed2dc78e0b7ebda1fd5fa37b40d184699ba27fb5d6edd13b8cf84531"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-aarch64-linux-jdk.tar.gz"
      sha256 "5ee984d59dfc54fec798c908618c1b952622232d3b458a439b4ecfbc461cae5a"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz"
      sha256 "076ab46faa8606366a33f5ac3bcc5d880dde23ab91d827fedc05e1367592c902"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
