class Sapmachine < Formula
  desc "SAP's distribution of OpenJDK"
  homepage "https://github.com/SAP/SapMachine"
  version "sapmachine-27.0.1.0.3"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1.0.3/sapmachine-jdk-27.0.1.0.3_macos-aarch64_bin.tar.gz"
      sha256 "07a3b725d298fcba2fc475aaa17c8cc20af40401f73299dc631ce92eaa69387c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1.0.3/sapmachine-jdk-27.0.1.0.3_linux-aarch64_bin.tar.gz"
      sha256 "62135a352b0baa224caa4400d58d56daaede3f553f2ea45c05024e2fcd89d48e"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-27.0.1.0.3/sapmachine-jdk-27.0.1.0.3_linux-x64_bin.tar.gz"
      sha256 "f76343142101b3b5e7cfecf664b55feeac4c9ce6df464f339ae27cda8234f637"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
