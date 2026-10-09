class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.6.4"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.4/quarkdown-macos-aarch64.zip"
      sha256 "b465efd8cb7a064ec31e64d687982051402af98e587c397159824fc057acd7ca"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.4/quarkdown-macos-x64.zip"
      sha256 "383b70223f03aa87a977be3eebd731e1da4aea2d4a12431f0d3c8ff820892d23"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.4/quarkdown-linux-x64.zip"
      sha256 "b2ec84dbae47925a2db92aa3bc085ee8aec03fec69b82629d8619164bfd75b02"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
