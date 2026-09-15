class Sapmachine < Formula
  desc "SAP's distribution of OpenJDK"
  homepage "https://github.com/SAP/SapMachine"
  version "sapmachine-27"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27/sapmachine-jdk-27_macos-aarch64_bin.tar.gz"
      sha256 "d11f398a0f518e238daae90db03a802c13a105288385c6c4e139a7de487ce56b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27/sapmachine-jdk-27_linux-aarch64_bin.tar.gz"
      sha256 "cee720ad293ade5c13d2a8f286e7c2f4a58b09c3623b6c5c44757b22c7f3f58b"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27/sapmachine-jdk-27_linux-x64_bin.tar.gz"
      sha256 "de400f5991c440d9a454e8d6470cec398ed5cf13277ba890d519d8c661bd8194"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
