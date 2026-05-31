class GraalvmCeJdk17 < Formula
  desc "GraalVM Community Edition JDK 17 - high-performance JDK distribution"
  homepage "https://www.graalvm.org/"
  version "17.0.9"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.9/graalvm-community-jdk-17.0.9_macos-aarch64_bin.tar.gz"
      sha256 "3eccc4ffda01818172b7fc7cdf4379bc62ed7129ee30ca854c04da67057249c9"
    end
    on_intel do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.9/graalvm-community-jdk-17.0.9_macos-x64_bin.tar.gz"
      sha256 "543dd286d99c04788847ef6366f794c059a69e77added577916186371e206e33"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.9/graalvm-community-jdk-17.0.9_linux-aarch64_bin.tar.gz"
      sha256 "c3281b21f5220c2f76cf6fa0d646bc42e2d729af2c022bb06e557a613ba16102"
    end
    on_intel do
      url "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.9/graalvm-community-jdk-17.0.9_linux-x64_bin.tar.gz"
      sha256 "e47ba7229cef02393e19d5b8f46f7f1cab4829dd17bfe84d5431fc8ff0e22a96"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
