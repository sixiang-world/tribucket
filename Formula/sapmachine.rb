class Sapmachine < Formula
  desc "SAP's distribution of OpenJDK"
  homepage "https://github.com/SAP/SapMachine"
  version "sapmachine-25.0.4"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-25.0.4/sapmachine-jdk-25.0.4_macos-aarch64_bin.tar.gz"
      sha256 "015045629129c68ec9bf91c4659b3cc3a9a9a783aec55ca01577ab3397e51bc1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-25.0.4/sapmachine-jdk-25.0.4_linux-aarch64_bin.tar.gz"
      sha256 "b9e14cbc9e66714162d9b13b8fd9e6568e9d8db5f518988f58e8256b9e677171"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-25.0.4/sapmachine-jdk-25.0.4_linux-x64_bin.tar.gz"
      sha256 "fc3851ec41715a4fccb30820a10c8ceaac161175567ea784de7dffae47eedc3a"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
