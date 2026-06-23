class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.3.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.3.1/quarkdown-macos-aarch64.zip"
      sha256 "92d43d59d4a02cf93d6a0cec620d44d0f1b3a59d95ff0557c9453ceff04c6503"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.3.1/quarkdown-macos-x64.zip"
      sha256 "83eb6a36d8da410897f6cd631732bffa981249ab252451c3d762acb04659ae0b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.3.1/quarkdown-linux-x64.zip"
      sha256 "57afec05945ae5d778319c6292e70c8a704770a41e41837689b8753c53995556"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
