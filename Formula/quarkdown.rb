class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.4.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.4.0/quarkdown-macos-aarch64.zip"
      sha256 "013776f65c22cdb73cfb5a25ec5c4ba764db9a21bdacca04d8b4fea93eea517d"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.4.0/quarkdown-macos-x64.zip"
      sha256 "9f413de9eb7323cf89ffb6e5a0d3709a6449bc464d03de2e6a340aedf437dd74"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.4.0/quarkdown-linux-x64.zip"
      sha256 "3fdb433ee307b6ce9f023ae01aba2dd446a1bc40856899a50682c1075e9facf0"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
