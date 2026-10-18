class Starship < Formula
  desc "Cross-shell prompt customization"
  homepage "https://github.com/starship/starship"
  version "1.27.0"
  license "ISC"

  on_macos do
    on_arm do
      url "https://github.com/starship/starship/releases/download/v1.27.0/starship-aarch64-apple-darwin.tar.gz"
      sha256 "5362da8cb2928f98f3ce0ffda697cf0f8de70081db000dae316d6d3a404f6cf0"
    end
    on_intel do
      url "https://github.com/starship/starship/releases/download/v1.27.0/starship-x86_64-apple-darwin.tar.gz"
      sha256 "344e4d38787e0aa86dd522ae5462e6fb6da1227691f81a79ffed480a4563ccb3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/starship/starship/releases/download/v1.27.0/starship-aarch64-unknown-linux-musl.tar.gz"
      sha256 "341f5cbf24699fa0b27ec88965ad25f862ea09e15d35a543fd6ffdff1d2aa00d"
    end
    on_intel do
      url "https://github.com/starship/starship/releases/download/v1.27.0/starship-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3b94758850901717eb36aa1b53f8492c1322506ec6d41273bc6151e79ed8e4a1"
    end
  end

  def install
    bin.install Dir["starship*"].first => "starship"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/starship --version 2>&1", 1)
  end
end
