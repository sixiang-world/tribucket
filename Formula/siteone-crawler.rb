class SiteoneCrawler < Formula
  desc "Cross-platform website crawler and analyzer for SEO, security, and performance"
  homepage "https://github.com/janreges/siteone-crawler"
  version "2.5.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/janreges/siteone-crawler/releases/download/v2.5.1/siteone-crawler-v2.5.1-macos-arm64.tar.gz"
      sha256 "6b893a15ce695a002bbe6c3d2467954fee64059216d471fae55c781936d96e2f"
    end
    on_intel do
      url "https://github.com/janreges/siteone-crawler/releases/download/v2.5.1/siteone-crawler-v2.5.1-macos-x64.tar.gz"
      sha256 "724639bdfca7d26514a7c3f10caa6a9172a4f2192744d9e4691bcf842b2e4609"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/janreges/siteone-crawler/releases/download/v2.5.1/siteone-crawler-v2.5.1-linux-arm64.tar.gz"
      sha256 "aa0bc9b2d7c7da5b871d2326d91183ef7c3107e005ef16dba69c78c5e406f83e"
    end
    on_intel do
      url "https://github.com/janreges/siteone-crawler/releases/download/v2.5.1/siteone-crawler-v2.5.1-linux-x64.tar.gz"
      sha256 "09278d958d4a087fa46093805cd33b085b96618001dd31d45c448ad724c9024e"
    end
  end

  def install
    bin.install Dir["siteone-crawler*"].first => "siteone-crawler"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/siteone-crawler --version 2>&1", 1)
  end
end
