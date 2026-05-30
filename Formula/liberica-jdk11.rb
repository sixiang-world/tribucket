class LibericaJdk11 < Formula
  desc "BellSoft Liberica JDK 11 - open-source Java implementation"
  homepage "https://bell-sw.com/java"
  version "11.0.31+11"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/bell-sw/Liberica/releases/download/11.0.31+11/bellsoft-jdk11.0.31+11-macos-aarch64.tar.gz"
      sha256 "d107e92230a5f95050f318092fe98c6d7f933b22cdc3ca340ef02e4fa17b8055"
    end
    on_intel do
      url "https://github.com/bell-sw/Liberica/releases/download/11.0.31+11/bellsoft-jdk11.0.31+11-macos-amd64.tar.gz"
      sha256 "a94e172cc8b8ed4a491124f82085970090b569a311fc36d6fb7eaee1c69c578a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bell-sw/Liberica/releases/download/11.0.31+11/bellsoft-jdk11.0.31+11-linux-aarch64.tar.gz"
      sha256 "25c1c25375cf7c71b020805a428546a122e9becae66e5e9b84986b88fbdb8f25"
    end
    on_intel do
      url "https://github.com/bell-sw/Liberica/releases/download/11.0.31+11/bellsoft-jdk11.0.31+11-linux-amd64.tar.gz"
      sha256 "579d283f92e4a45a3d809312ab8ceb3890cfced65e48ecf9a99e77ce88634fa4"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
