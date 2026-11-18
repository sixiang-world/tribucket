class MicrosoftJdk11 < Formula
  desc "Microsoft Build of OpenJDK 11"
  homepage "https://learn.microsoft.com/java/openjdk/overview"
  version "11"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-macos-aarch64.tar.gz"
      sha256 "1b516ffe4df3bcf3f916420b8887b865f6f54561e73bfc7f7e628d4d2179d7fd"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-macos-x64.tar.gz"
      sha256 "322027d811eecc7078733c4024e86b7ee08db762e8a884fd02e8a37cbe17971c"
    end
  end

  on_linux do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-linux-aarch64.tar.gz"
      sha256 "03b1a09eb3e274123434f9224dda3bafc675bfc5d8386db0b8bc12b1192b9136"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-linux-x64.tar.gz"
      sha256 "aadc35414317a23db3827b284a5865fd74ec662f26c1f94f200136d9fc9248e3"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
