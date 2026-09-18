class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.6.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.1/quarkdown-macos-aarch64.zip"
      sha256 "c451111c0504a7e0452b939cefd14eeb84034dc6fad0cfb4718f7b05e0a6c39f"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.1/quarkdown-macos-x64.zip"
      sha256 "7a0c8123ccf5cda00a6a97a14066e5aff0ce165426db24f4d9076247ef180261"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.1/quarkdown-linux-x64.zip"
      sha256 "635402945449a7992a555d4e42854a6af340a2e3be8b0e246674703af4b345c8"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
