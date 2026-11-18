class CorrettoJdk21 < Formula
  desc "Amazon Corretto - no-cost, production-ready distribution of OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "21.0.11.10.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-macos-jdk.tar.gz"
      sha256 "3e566c5b2760dc4f2199ac68b09a1b7c5381f228a336f3514a1aad4c113d474a"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-macos-jdk.tar.gz"
      sha256 "83095d9de2fe412151eede49e0373eeb5290bc0b82cc60cedb35e1da2d0a5ecc"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-linux-jdk.tar.gz"
      sha256 "55751c47c7e3be3b33af43ccdcf3a6f4814d308390b7400477594d421bd16a53"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.tar.gz"
      sha256 "2aaa2a9a43143b20ff0b28c8d0da27407b97dc40b160d9a2f60a26965815e948"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
