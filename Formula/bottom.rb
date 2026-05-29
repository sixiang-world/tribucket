class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.12.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.12.3/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "106e9493d20192d18dbe46d4c99f680d817c796724103ee258567070fcd16429"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.12.3/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "5744b5c78db14b85e025c31ded93ba038041e6ff2e8c16ea1d2f9bdb6487316f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.12.3/bottom_aarch64-linux-android.tar.gz"
      sha256 "1dc1de0041e0de6b2febf016435118523fdf09f90b03e8998e03a23ad7eb6c40"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.12.3/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "468131d586dee6f4cce23fae597646cfd032103ecf749a478acb9d236adab6d6"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
