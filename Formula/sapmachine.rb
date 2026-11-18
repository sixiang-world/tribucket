class Sapmachine < Formula
  desc "SAP's distribution of OpenJDK"
  homepage "https://github.com/SAP/SapMachine"
  version "sapmachine-27.0.1.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1.1/sapmachine-jdk-27.0.1.1_macos-aarch64_bin.tar.gz"
      sha256 "4c4fc9296c03273e6d4baf8bda45d1f0693871a1de4c720ccf83c21ed61f2c76"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1.1/sapmachine-jdk-27.0.1.1_linux-aarch64_bin.tar.gz"
      sha256 "57558624d7e88663066410c90586603f58479a2fc7f1672e87379d3abc08204f"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1.1/sapmachine-jdk-27.0.1.1_linux-x64_bin.tar.gz"
      sha256 "3245b5678e7a1dafd38637a12f795518f13e2781fd1a6d23629f0200fd397139"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
