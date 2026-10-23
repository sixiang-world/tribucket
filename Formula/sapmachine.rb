class Sapmachine < Formula
  desc "SAP's distribution of OpenJDK"
  homepage "https://github.com/SAP/SapMachine"
  version "sapmachine-27.0.1.0.2"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1.0.2/sapmachine-jdk-27.0.1.0.2_macos-aarch64_bin.tar.gz"
      sha256 "7efe986d7a949fa4a446a5f32912e66ebc66a4a134bc621cc5d33dd4d1222337"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1.0.2/sapmachine-jdk-27.0.1.0.2_linux-aarch64_bin.tar.gz"
      sha256 "9f28793a16133009dba3a94bde62468b2bc99aff6d2b292a978123018b0f42fb"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1.0.2/sapmachine-jdk-27.0.1.0.2_linux-x64_bin.tar.gz"
      sha256 "431bb9e699b5e3ff78e272be13b01795ab63e7a1d9a5df6107eca5b61e99a4e8"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
