class MicrosoftJdk17 < Formula
  desc "Microsoft Build of OpenJDK 17"
  homepage "https://learn.microsoft.com/java/openjdk/overview"
  version "17"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-macos-aarch64.tar.gz"
      sha256 "a61837df9f18cf8c5bcff5c87b4f69267783d9eeb7d8ecbd05a831a530fb99de"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-macos-x64.tar.gz"
      sha256 "ecd3f6f9c84b8fc06f1b2ddfd50759dbc95bbe6c2412161ea0cf9f525ea573aa"
    end
  end

  on_linux do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-linux-aarch64.tar.gz"
      sha256 "80a60422e032418ed25c503482b0cb1da82e0e05179a99500142993b56e148f1"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-linux-x64.tar.gz"
      sha256 "d00e5b04e9726b63d915706c7049e5297c9f40239ce8a12fcc68b7267fa91ad2"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
