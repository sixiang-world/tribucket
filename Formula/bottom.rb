class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.14.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.3/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "ef37c83382359e3b098e1311e3ea933c4f5d0e3042709887a68c102d607c973d"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.3/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "98a5b42c274617bae1ecf74e0e8fa03bf56d2c064130c6330a4157c9fff8c25a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.3/bottom_aarch64-linux-android.tar.gz"
      sha256 "32c5e020f8433e7ef6c5bb6b923f5d5a83ab1e01bb23ce3cba2bd53d56c8c760"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.3/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "09961b35e7a0dbd29c89940d884ab771ddecb738e38cafe2bc421f7908349c51"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
