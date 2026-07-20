class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.14.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.6/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "f599b679e447e76f96fe6923d82870a87af082a5211e7389067c6572c337240e"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.6/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "aa7c899ffa55468f20524ce6aa1dc263450394d233a34dd4790d7e0c63224487"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.6/bottom_aarch64-linux-android.tar.gz"
      sha256 "d99b36eef50afc69499d41b161de44aa0572f1019314bcd839ca00bad13db12b"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.6/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "574c4f99a89b5ac71fb9c6f0cd947c9642ab08d7f62dcefd368c36ce79d4ec28"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
