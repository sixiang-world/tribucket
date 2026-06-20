class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.13.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.13.0/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "1769fd7746e0bb16c912ccb2fadeb912d88bb29e82f47561d2d2f34c0982f6f4"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.13.0/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "481c5ea2b4f6130949ba1f36050f7bd444da62330f9420d92e337b481e1a8e2e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.13.0/bottom_aarch64-linux-android.tar.gz"
      sha256 "4f9fa704263f8272d0f9ba15889647b196b67595c01077d711da305c94fda01e"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.13.0/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "684e106887db097087ce5ddd5fe600a8186b478b539c77a04c2809290ac1f84b"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
