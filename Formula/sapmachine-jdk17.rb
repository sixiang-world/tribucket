class SapmachineJdk17 < Formula
  desc "SAP SapMachine JDK 17 - SAP's distribution of OpenJDK"
  homepage "https://sap.github.io/SapMachine/"
  version "17.0.19"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-17.0.19/sapmachine-jdk-17.0.19_macos-aarch64_bin.tar.gz"
      sha256 "a98bd4b0f2f0e253ef670ac651205afc4a235db470809b6730e990c0e51705d6"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-17.0.19/sapmachine-jdk-17.0.19_macos-x64_bin.tar.gz"
      sha256 "e1da0fa345e11dd12e70b462a7e39abead4be645d96fdeeb1169a69e03f59d24"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-17.0.19/sapmachine-jdk-17.0.19_linux-aarch64_bin.tar.gz"
      sha256 "84741adf2fa5a5224c9467b66dfa5f21f438ac867d6ba5080858c9a006a0923a"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-17.0.19/sapmachine-jdk-17.0.19_linux-x64_bin.tar.gz"
      sha256 "6fe7413b5fb62d8307249987fc2863dfa817b54755a4b865e1b4215fbaa7d242"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
