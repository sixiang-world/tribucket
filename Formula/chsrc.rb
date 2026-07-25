class Chsrc < Formula
  desc "Full-platform universal source changing tool and framework"
  homepage "https://github.com/RubyMetric/chsrc"
  version "0.2.6"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.6/chsrc-aarch64-macos"
      sha256 "9ca5b2fd01ac341aa435414a622fef96a77e5f025c1517ee84476625680977cf"
    end
    on_intel do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.6/chsrc-x64-macos"
      sha256 "4ac581f462c63c116f3abe703607cfca898e09753fc9f1c9fb7d24713f18b7d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.6/chsrc-aarch64-linux"
      sha256 "9c469b3fe63a66eca60aff1b3be77747763f8c4893e44185b743c5338a693741"
    end
    on_intel do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.6/chsrc-x64-linux"
      sha256 "6b34e8f6b1ae7ea1434b12ab22df992bcc14dbbf2fdced2783c0d17cbae19673"
    end
  end

  def install
    bin.install Dir["chsrc*"].first => "chsrc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chsrc --version 2>&1", 1)
  end
end
