class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.4.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.4.1/quarkdown-macos-aarch64.zip"
      sha256 "40ceb1f6e4e9b3ca4953cb3d5d6c8837f84db9dff3a9bfa56f63cdd1008ca232"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.4.1/quarkdown-macos-x64.zip"
      sha256 "115514277d44185531cc7a1f2387bade2ecadcddb802b6c7c95d5321cd312846"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.4.1/quarkdown-linux-x64.zip"
      sha256 "f6161298a2d0e7139ab405474495e9b188979e2ff1e761638bdb17ae1c0cb2b1"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
