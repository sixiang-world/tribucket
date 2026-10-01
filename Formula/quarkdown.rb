class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.6.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.3/quarkdown-macos-aarch64.zip"
      sha256 "6624ea677c8cb37616748d759c27912d7c851a9ffac73726456fe7219f129779"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.3/quarkdown-macos-x64.zip"
      sha256 "4e6be4d64c7204797bf8f0fe388afa816c5333db248693f2c123972a9b9c682c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.6.3/quarkdown-linux-x64.zip"
      sha256 "f39bc7fe94444743bc4b3a9387e08bfc1abba12b026f9102bab89f7cc1e1532b"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
