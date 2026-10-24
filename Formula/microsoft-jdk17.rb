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
      sha256 "fc80cf268662b058a7b360fb118f9a729987932d1ab8d72c5813e86df89c6034"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-linux-x64.tar.gz"
      sha256 "f7230e6d76ccfd62ceb11687a24e93d1f63d236e6a5fdeb8d923700075de42f8"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
