class GraalvmCeJdk21 < Formula
  desc "GraalVM Community Edition - high-performance JDK with ahead-of-time compilation"
  homepage "https://github.com/graalvm/graalvm-ce-builds"
  version "graal-25.3.4.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-25.3.4.1/graalvm-community-jdk-25i3-25.0.4.1_macos-aarch64_bin.tar.gz"
      sha256 "ebfab1d74420f355a459076162012d6835fa6068bd9d2f230f1fcaf7ee0dd923"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-25.3.4.1/graalvm-community-jdk-25i3-25.0.4.1_linux-aarch64_bin.tar.gz"
      sha256 "7e8a3fbc2e4c28566107039a298cef690d86a37599a8e50536fc5a65b7f1bd56"
    end
    on_intel do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-25.3.4.1/graalvm-community-jdk-25i3-25.0.4.1_linux-x64_bin.tar.gz"
      sha256 "b2bc38d0c4141426eb44d0eefa3cc172c96faf92727d703b61541699128b6fc7"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
