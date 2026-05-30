class GraalvmCeJdk21 < Formula
  desc "GraalVM Community Edition - high-performance JDK with ahead-of-time compilation"
  homepage "https://github.com/graalvm/graalvm-ce-builds"
  version "jdk-25.0.2"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-25.0.2/graalvm-community-jdk-25.0.2_macos-aarch64_bin.tar.gz"
      sha256 "50201fb8e8e653e7a253d955877a6b6ad634b42e60c84f45df7e1bb51361635f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-25.0.2/graalvm-community-jdk-25.0.2_linux-aarch64_bin.tar.gz"
      sha256 "b4580d9f223d0a4b3a1757e58b18ff4c1db950e67e105fc5cb741457d2384a71"
    end
    on_intel do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-25.0.2/graalvm-community-jdk-25.0.2_linux-x64_bin.tar.gz"
      sha256 "e0be791c8fda4d03b6b0a0cb824fef3149736170057b3a515252b44419606af0"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
