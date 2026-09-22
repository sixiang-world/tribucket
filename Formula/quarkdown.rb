class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.6.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.2/quarkdown-macos-aarch64.zip"
      sha256 "3b11d2b61c1f5ca33b5b0e0102e71202d3f37bb0538aca719b88930cf40fa3ca"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.2/quarkdown-macos-x64.zip"
      sha256 "043e4162589221b5e4b909eebe7d63399942728af75d931f9dadb3cc06f67edc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.2/quarkdown-linux-x64.zip"
      sha256 "84314977298511662c3053f7c1d24c0236ff19c5baa07807142fc034d7ae24fa"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
