class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.1.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.1.2/quarkdown-macos-aarch64.zip"
      sha256 "26380b41b7dc1f4a16136ab1d769dccd93f2d9695699e69d9c0112fc4d6f70fc"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.1.2/quarkdown-macos-x64.zip"
      sha256 "0e3ad748a271077c8e6f8d1552955b5c106d69a3b9ab3445bb19c2194c2f194f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.1.2/quarkdown-linux-x64.zip"
      sha256 "c5073172bc5b91241f9d86cfe8c454424c6a128a750ab30b8d3602a9a373a4a0"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
