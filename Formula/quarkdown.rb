class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.7.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.7.0/quarkdown-macos-aarch64.zip"
      sha256 "60afe5ab3d2dad10355eea2ec9ca477f229c6f4c5be27a4d0338b5ed00add919"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.7.0/quarkdown-macos-x64.zip"
      sha256 "b0ea3cb964f6d6e0b64a32db88c1eb40615fe851d2a153019b260123d8f550c0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.7.0/quarkdown-linux-x64.zip"
      sha256 "5ff4e78e391abd073e62030da816faef265d681d3b8ccfd05768cc9c586f7e85"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
