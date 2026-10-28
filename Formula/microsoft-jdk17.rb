class MicrosoftJdk17 < Formula
  desc "Microsoft Build of OpenJDK 17"
  homepage "https://learn.microsoft.com/java/openjdk/overview"
  version "17"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-macos-aarch64.tar.gz"
      sha256 "6bc0241428f9485a3aa8fcf606c8395c24a5ff0f6d5e9dae2c70eae410a3f5f3"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-macos-x64.tar.gz"
      sha256 "4a5f9e0cb0bb33c841e29cd6bb6d0eaf32893a5d404ea027d2b5123b72977ce5"
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
