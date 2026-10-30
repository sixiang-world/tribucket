class TencentKonaJdk21 < Formula
  desc "Tencent Kona - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "TencentKona-21.0.13.0.3"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.13.0.3/TencentKona-21.0.13.0.3.b1_jdk_macosx-aarch64_notarized.tar.gz"
      sha256 "2e64f0dbe2c1ed4b71bd083a6623f4b12a55ea6de210a627b5a6eb43ad1d8df1"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.13.0.3/TencentKona-21.0.13.0.3.b1_jdk_macosx-x86_64_notarized.tar.gz"
      sha256 "a9e7f122ff2ad504826c02c006db5828d58c380e480248e37a57e6a12455b7dd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.13.0.3/TencentKona-21.0.13.0.3.b1-jdk_linux-aarch64.tar.gz"
      sha256 "6248693a8be9af89fa811a92fd68a9b20f5ae2b8716029cfc11ee427a6fc48e2"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.13.0.3/TencentKona-21.0.13.0.3.b1-jdk_linux-x86_64.tar.gz"
      sha256 "6d91a9272966c16bfd877322236e645abfffcd1b599b3b1285492fd2b85b5d4b"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
