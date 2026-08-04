class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.5.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.5.0/quarkdown-macos-aarch64.zip"
      sha256 "36eb07416039a1ba7a06d8db26dc4a96ac818bfc69560c422fd357a6abbf355b"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.5.0/quarkdown-macos-x64.zip"
      sha256 "2917dc4a27d23b6bb864e1d8e23f256495c461ecfa99c8513aa736549c097825"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.5.0/quarkdown-linux-x64.zip"
      sha256 "f261e49cdb0ba420781ad8f25bb0f2422ceed6186c47f3d52ab3408d8bb30ba1"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
