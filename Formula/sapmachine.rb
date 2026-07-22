class Sapmachine < Formula
  desc "SAP's distribution of OpenJDK"
  homepage "https://github.com/SAP/SapMachine"
  version "sapmachine-26.0.2"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-26.0.2/sapmachine-jdk-26.0.2_macos-aarch64_bin.tar.gz"
      sha256 "1d9843eb273c9f0d9917adc2c838176ac25499e2a9694c5f129ff2a2ae5d7df1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-26.0.2/sapmachine-jdk-26.0.2_linux-aarch64_bin.tar.gz"
      sha256 "d5cdee567aaac43d34ea8730689c6de2b304b7a3d3f2378b086acf9af66394b0"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-26.0.2/sapmachine-jdk-26.0.2_linux-x64_bin.tar.gz"
      sha256 "eecb8a3ea8e853c4e036ec0558e7d4b74ed68cbf7fa1ec3a6ff592485cf924f6"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
