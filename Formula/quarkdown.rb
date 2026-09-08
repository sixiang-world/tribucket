class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.6.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.0/quarkdown-macos-aarch64.zip"
      sha256 "98efdb378cee11accf8b2d171d483da749785f8a70eddd8d31ea2bb82224a894"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.0/quarkdown-macos-x64.zip"
      sha256 "dbd48e2d507c2368464c253db237164e496299f086bdee9dccaf4f608fc38249"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.0/quarkdown-linux-x64.zip"
      sha256 "5b015e47c820d06ff6774eb700e60d77bc575819d4a0140cc7f1a115e7ce6dc4"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
