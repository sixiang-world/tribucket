class SiteoneCrawler < Formula
  desc "Cross-platform website crawler and analyzer for SEO, security, and performance"
  homepage "https://github.com/janreges/siteone-crawler"
  version "2.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/janreges/siteone-crawler/releases/download/v2.3.0/siteone-crawler-v2.3.0-macos-arm64.tar.gz"
      sha256 "5a412734fdff6d6a25a4fa8bf2436b9399909923e206259a6fb111fe77bedafd"
    end
    on_intel do
      url "https://github.com/janreges/siteone-crawler/releases/download/v2.3.0/siteone-crawler-v2.3.0-macos-x64.tar.gz"
      sha256 "4187e98b0b8c52eeb428afe82edcbb85661ab5a321c68bd478efc55779e9afd4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/janreges/siteone-crawler/releases/download/v2.3.0/siteone-crawler-v2.3.0-linux-arm64.tar.gz"
      sha256 "fb30192ec52edf28883ad54062cbfa03894a272a8535ef8b1036347f2e9052cf"
    end
    on_intel do
      url "https://github.com/janreges/siteone-crawler/releases/download/v2.3.0/siteone-crawler-v2.3.0-linux-x64.tar.gz"
      sha256 "76310c8723bb9cffb91550b6c617b61ca1ae3061ed92b2af640923da58c96fe8"
    end
  end

  def install
    bin.install Dir["siteone-crawler*"].first => "siteone-crawler"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/siteone-crawler --version 2>&1", 1)
  end
end
