class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.5.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.5.1/quarkdown-macos-aarch64.zip"
      sha256 "3cbfb9a995e0ec9412a54b0667af609b6b0526a5f77a8dade9317a1f262b296c"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.5.1/quarkdown-macos-x64.zip"
      sha256 "a5d81220ad9bed2515786dcf7dc9ddfbbdc6059992bcf856b40f71eeb5673927"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.5.1/quarkdown-linux-x64.zip"
      sha256 "5751ab608fcb4daa2ec857a3368c029beed5429554ae0bdd95c660b2706269e9"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
