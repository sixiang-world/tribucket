class MicrosoftJdk11 < Formula
  desc "Microsoft Build of OpenJDK 11"
  homepage "https://learn.microsoft.com/java/openjdk/overview"
  version "11"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-macos-aarch64.tar.gz"
      sha256 "5b56e9658e4f08b0ed5aa9c914213b5214de299c85e8668892d169c37ba134bc"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-macos-x64.tar.gz"
      sha256 "f4c6d69692e27b33ed39b89d096cfcfb2dae0d5bbce78c5dc3123d507bd7d049"
    end
  end

  on_linux do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-linux-aarch64.tar.gz"
      sha256 "d03b59954d3a516c130223b74c59ba1246c0d3195ff0faf9f70b79e25e07e685"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-linux-x64.tar.gz"
      sha256 "aaf6ec8ed756256ec49fe96ebec2f57676c17107774f81e1e0d14c84a1094c6c"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
