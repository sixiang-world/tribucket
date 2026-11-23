class TencentKonaJdk21 < Formula
  desc "Tencent Kona - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "TencentKona-21.0.13.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.13.1/TencentKona-21.0.13.1.b1_jdk_macosx-aarch64_notarized.tar.gz"
      sha256 "c19c949ef222e9be24498f92bcc47f31ad12842859938fb331c718b2bbc8cefa"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.13.1/TencentKona-21.0.13.1.b1_jdk_macosx-x86_64_notarized.tar.gz"
      sha256 "11ef8b66abc8dabb8b2167abddc1b96534f123c37f6cc14bc79c5acf647a9ff1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.13.1/TencentKona-21.0.13.1.b1-jdk_linux-aarch64.tar.gz"
      sha256 "a6d84f0d8e106aeabcf90369182aff9757ab786b275147f7ac18b9d2235be30b"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.13.1/TencentKona-21.0.13.1.b1-jdk_linux-x86_64.tar.gz"
      sha256 "2af08edb568e21caa593a3d0c9070b046b64275be0afa4b0b7accc5771b1f9cf"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
