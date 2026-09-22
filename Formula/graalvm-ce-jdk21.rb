class GraalvmCeJdk21 < Formula
  desc "GraalVM Community Edition - high-performance JDK with ahead-of-time compilation"
  homepage "https://github.com/graalvm/graalvm-ce-builds"
  version "graal-25.4.4.1.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-25.4.4.1.1/graalvm-community-jdk-25i4-25.0.4.1.1_macos-aarch64_bin.tar.gz"
      sha256 "4ec9932aa4aab1afca0ea31982d32d6f956615c61fe21a227b49756b25adda4f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-25.4.4.1.1/graalvm-community-jdk-25i4-25.0.4.1.1_linux-aarch64_bin.tar.gz"
      sha256 "e5f5e2f59643cf96765c741dc00b206f86c69c8c1bf843fe26050c871e0e2dbc"
    end
    on_intel do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-25.4.4.1.1/graalvm-community-jdk-25i4-25.0.4.1.1_linux-x64_bin.tar.gz"
      sha256 "05ccbbe783210b6886ff7b08fcd0b061c5dce4852b05db87284fc0e24abb08e2"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
