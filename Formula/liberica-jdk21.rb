class LibericaJdk21 < Formula
  desc "BellSoft Liberica - 100% open-source Java implementation"
  homepage "https://bell-sw.com/java"
  version "21.0.11+11"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/bell-sw/Liberica/releases/download/21.0.11%2B11/bellsoft-jdk21.0.11+11-macos-aarch64.tar.gz"
      sha256 "6916528233b389ae70ef3cfc60352508b6a7c2c9f5d97ac066f54c3d3d420334"
    end
    on_intel do
      url "https://github.com/bell-sw/Liberica/releases/download/21.0.11%2B11/bellsoft-jdk21.0.11+11-macos-amd64.tar.gz"
      sha256 "327cc71b4f83eb82db8271f4a6176274d5ca288fa3455a4381a241ce9c3a193c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bell-sw/Liberica/releases/download/21.0.11%2B11/bellsoft-jdk21.0.11+11-linux-aarch64.tar.gz"
      sha256 "8557f3b38a537ddc912dd53c310767938310952e8e21d5cea85765aff046fc30"
    end
    on_intel do
      url "https://github.com/bell-sw/Liberica/releases/download/21.0.11%2B11/bellsoft-jdk21.0.11+11-linux-amd64.tar.gz"
      sha256 "22dbce922846eb5e17d6af40393ac6f4c1585b5a87ba2f63d6996bf0682b3d2b"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
