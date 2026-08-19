class Sapmachine < Formula
  desc "SAP's distribution of OpenJDK"
  homepage "https://github.com/SAP/SapMachine"
  version "sapmachine-26.0.2.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-26.0.2.1/sapmachine-jdk-26.0.2.1_macos-aarch64_bin.tar.gz"
      sha256 "5e77fe7f0f9eacac3b5ebbc683da503660448b17f75c0855d313c022b9f6979c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-26.0.2.1/sapmachine-jdk-26.0.2.1_linux-aarch64_bin.tar.gz"
      sha256 "0e5a5fa18f3adc4dbab98269f66d2a88dda3abba74e5b89a4a8f3b000f5ee0f7"
    end
    on_intel do
      url "https://github.com/SAP/SapMachine/releases/download/sapmachine-26.0.2.1/sapmachine-jdk-26.0.2.1_linux-x64_bin.tar.gz"
      sha256 "9c7920433f64b185028984b355cd966293fa8494a9f06c97bc5429716975f91f"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
