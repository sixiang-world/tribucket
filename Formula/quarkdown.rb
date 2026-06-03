class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.2.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.2.0/quarkdown-macos-aarch64.zip"
      sha256 "ce38ea83f8335f7d286a11e1fdd6e95923c4ebda0b7cc990b5409b7c38895412"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.2.0/quarkdown-macos-x64.zip"
      sha256 "874d55f58fa9439a55c2a2db19331e74bc9ad1bb3366b51383150f63201dc695"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.2.0/quarkdown-linux-x64.zip"
      sha256 "810b885087cdb41e07279311c0b0fb141d86ac89adf1b18533623d3c4eb97836"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
