class LibericaJdk17 < Formula
  desc "BellSoft Liberica JDK 17 - open-source Java implementation"
  homepage "https://bell-sw.com/java"
  version "17.0.19+11"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/bell-sw/Liberica/releases/download/17.0.19+11/bellsoft-jdk17.0.19+11-macos-aarch64.tar.gz"
      sha256 "775422b31ea12eee6d8ad7ba3274f8020c2d7498e0db540f1cb94303ab0437ee"
    end
    on_intel do
      url "https://github.com/bell-sw/Liberica/releases/download/17.0.19+11/bellsoft-jdk17.0.19+11-macos-amd64.tar.gz"
      sha256 "e33efd956572589bffa3d0640c5c2b0d68d0329664a828bb3f7ed2aaf51fd3c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bell-sw/Liberica/releases/download/17.0.19+11/bellsoft-jdk17.0.19+11-linux-aarch64.tar.gz"
      sha256 "b0c78a97e0f9d341549fa398fd8845c2be460c4b1f67d22939e9cbd409b5e42a"
    end
    on_intel do
      url "https://github.com/bell-sw/Liberica/releases/download/17.0.19+11/bellsoft-jdk17.0.19+11-linux-amd64.tar.gz"
      sha256 "07130e800221b71e2c4ef04da115d255f93f42dde4e1cb0c826f8b5b928d27ad"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
