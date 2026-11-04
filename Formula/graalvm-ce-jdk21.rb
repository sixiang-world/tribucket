class GraalvmCeJdk21 < Formula
  desc "GraalVM Community Edition - high-performance JDK with ahead-of-time compilation"
  homepage "https://github.com/graalvm/graalvm-ce-builds"
  version "graal-25.5.5.0.3"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-25.5.5.0.3/graalvm-community-jdk-25i5-25.0.5.0.3_macos-aarch64_bin.tar.gz"
      sha256 "54369d4a5931a5a2101c7c52444a4e7e6647a3a4e041335053cda6fd22295e0c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-25.5.5.0.3/graalvm-community-jdk-25i5-25.0.5.0.3_linux-aarch64_bin.tar.gz"
      sha256 "41741c0650ae7564a78335f9e4fc353a902e6ff1d4140f2e4fabd1c55d5cce66"
    end
    on_intel do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-25.5.5.0.3/graalvm-community-jdk-25i5-25.0.5.0.3_linux-x64_bin.tar.gz"
      sha256 "c6438dee6c3ade2220d40b7ccdcad24b512d30e233e61bb4fc70519522de34ef"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
