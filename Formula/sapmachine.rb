class Sapmachine < Formula
  desc "SAP's distribution of OpenJDK"
  homepage "https://github.com/SAP/SapMachine"
  version "sapmachine-17.0.20"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-17.0.20/sapmachine-jdk-17.0.20_macos-aarch64_bin.tar.gz"
      sha256 "9c84d766eeb257208ccbb852b00ed3a88b5a92cc5ead6796266ba4d60ebbc574"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-17.0.20/sapmachine-jdk-17.0.20_linux-aarch64_bin.tar.gz"
      sha256 "267791d3d14c00af4596949642c6849e72d6ecef37d6a651d0cea81c3e849f2c"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-17.0.20/sapmachine-jdk-17.0.20_linux-x64_bin.tar.gz"
      sha256 "0219434d3528a6092add15926d2df7d10c55a8032a318ef3f7875fcb407ff4bc"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
