class Quarkdown < Formula
  desc "Markdown-to-PDF/document engine"
  homepage "https://github.com/iamgio/quarkdown"
  version "2.3.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.3.0/quarkdown-macos-aarch64.zip"
      sha256 "c5d3c50685c320714cad553c845ca045f36b8e226223fe98ff55a9063ce5371e"
    end
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.3.0/quarkdown-macos-x64.zip"
      sha256 "bcfe5c2ce551abfe81d98ac4072b8ec30d8bfc880305955f4e9eeea6f810712f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iamgio/quarkdown/releases/download/v2.3.0/quarkdown-linux-x64.zip"
      sha256 "e7ab415e35c5053b59efa9774cfaf10cfc54b70f80d0202680cfa52c5bfa275a"
    end
  end

  def install
    bin.install Dir["quarkdown*"].first => "quarkdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarkdown --version 2>&1", 1)
  end
end
