class MicrosoftJdk17 < Formula
  desc "Microsoft Build of OpenJDK 17"
  homepage "https://learn.microsoft.com/java/openjdk/overview"
  version "17"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-macos-aarch64.tar.gz"
      sha256 "dd01e975635e7d7d21f8862df63ec065c4dbf61a484c6c4468bb6ae022fc6986"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-macos-x64.tar.gz"
      sha256 "c430a3474f68cbaa50471b3291a951de408b3cb895943d0519369c75b81884d1"
    end
  end

  on_linux do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-linux-aarch64.tar.gz"
      sha256 "92427f17364dd508ddcd604dfa2a86fc9ec8c8d09364323ca7c15f63c5f6694a"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-linux-x64.tar.gz"
      sha256 "9143307aa5869cede4cbe09aac477256f08d8607e5c760dc040ef37ef2c2f5e7"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
