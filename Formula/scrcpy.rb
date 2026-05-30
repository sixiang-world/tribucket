class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  version "4.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Genymobile/scrcpy/releases/download/v4.0/scrcpy-macos-aarch64-v4.0.tar.gz"
      sha256 "f5167fe047fe4a2ae2c2ea8634c7145a4d64d0b6005f24bb45639a965b8c60d4"
    end
    on_intel do
      url "https://github.com/Genymobile/scrcpy/releases/download/v4.0/scrcpy-macos-x86_64-v4.0.tar.gz"
      sha256 "b83169f856d7022ed0e4428d98acea18dde2d63f49611b52ea137577ce4efe6b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Genymobile/scrcpy/releases/download/v4.0/scrcpy-linux-x86_64-v4.0.tar.gz"
      sha256 "7daf05af5d575862e62b068cf6852d6068faf7ef3178f3735e3953e778fbf0ab"
    end
  end

  def install
    bin.install Dir["scrcpy*"].first => "scrcpy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrcpy --version 2>&1", 1)
  end
end
