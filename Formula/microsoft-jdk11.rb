class MicrosoftJdk11 < Formula
  desc "Microsoft Build of OpenJDK 11"
  homepage "https://learn.microsoft.com/java/openjdk/overview"
  version "11"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-macos-aarch64.tar.gz"
      sha256 "c1efc666076916a8ecbc2346ca588dfac7375ad4a53a383618d7c124febbc00e"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-macos-x64.tar.gz"
      sha256 "e3bfbb68969a90c45495381093eba3225d85a71197ccc6779b992d2d199ef256"
    end
  end

  on_linux do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-linux-aarch64.tar.gz"
      sha256 "a9102ad6478832df70ff1f35994c1c28aced8d8d4160cbca6688cad5133c4548"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-linux-x64.tar.gz"
      sha256 "835411604b321042db7191479d9039f45d138f3d505183e24c3fad1713ed7fc0"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
