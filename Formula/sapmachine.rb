class Sapmachine < Formula
  desc "SAP's distribution of OpenJDK"
  homepage "https://github.com/SAP/SapMachine"
  version "sapmachine-26.0.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-26.0.1/sapmachine-jdk-26.0.1_macos-aarch64_bin.tar.gz"
      sha256 "3663faab53b08e20c87112166bae3399340ead434d8e3a58cbb2a28ef1e0c584"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-26.0.1/sapmachine-jdk-26.0.1_linux-aarch64_bin.tar.gz"
      sha256 "842d91f9d65026a37a0095545abd17dec3b0f44211d22838a499b27c2ec0389f"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-26.0.1/sapmachine-jdk-26.0.1_linux-x64_bin.tar.gz"
      sha256 "4422a642da9764419477a80bea1d614391c40b71060f0de1610467d4c70807a0"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
