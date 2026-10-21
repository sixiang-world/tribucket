class Sapmachine < Formula
  desc "SAP's distribution of OpenJDK"
  homepage "https://github.com/SAP/SapMachine"
  version "sapmachine-27.0.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1/sapmachine-jdk-27.0.1_macos-aarch64_bin.tar.gz"
      sha256 "fc4fd1499c07cc521c1b90ea5587bbbb374ec71507df721a18cc334a0731a8bb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1/sapmachine-jdk-27.0.1_linux-aarch64_bin.tar.gz"
      sha256 "92e3a2d0587408aa8aa2ffb53e79144414af5ff34e2489e9ae71653876d0ef15"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1/sapmachine-jdk-27.0.1_linux-x64_bin.tar.gz"
      sha256 "44b0fdfa9a7069bf36abe181964f7b184808ee0bf606cf7fe9d2543770f10579"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
