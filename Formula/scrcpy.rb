class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  version "5.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Genymobile/scrcpy/releases/download/v5.0/scrcpy-macos-aarch64-v5.0.tar.gz"
      sha256 "7cb4e41c859b05b36e89dc9be6c353cc5980c00d7f7f6a763b5b355551b82e9c"
    end
    on_intel do
      url "https://github.com/Genymobile/scrcpy/releases/download/v5.0/scrcpy-macos-x86_64-v5.0.tar.gz"
      sha256 "dacb995c8eb42528cb96b2da2a2e3110fe5c82281378e6044fc7cccf48a7c39a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Genymobile/scrcpy/releases/download/v5.0/scrcpy-linux-x86_64-v5.0.tar.gz"
      sha256 "f052ad9eb981879e8c5f066c5ef122b39b6c9853b383d6497219030e6549baed"
    end
  end

  def install
    bin.install Dir["scrcpy*"].first => "scrcpy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrcpy --version 2>&1", 1)
  end
end
