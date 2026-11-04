class Surrealdb < Formula
  desc "Scalable, distributed document-graph database"
  homepage "https://github.com/surrealdb/surrealdb"
  version "4.0.0"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v4.0.0/surreal-v4.0.0.darwin-arm64.tgz"
      sha256 "9e0b48796d73308bc717936142b676f3c83c58980275f784e738051eca8f6a18"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v4.0.0/surreal-v4.0.0.darwin-amd64.tgz"
      sha256 "7ef3eecf5b1a3e31928784e4a7a91f943ec8d882fe22df5cdf7e6c7b37ea771f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v4.0.0/surreal-v4.0.0.linux-arm64.tgz"
      sha256 "3d0feff9c3b56a05f168175bd1585e144093c36e740c32c40cf6e51d3466b81c"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v4.0.0/surreal-v4.0.0.linux-amd64.tgz"
      sha256 "e910760179b9f13d0773ce98ac50f9a537051156365239284c2dc687adf3049d"
    end
  end

  def install
    bin.install Dir["surreal*"].first => "surreal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surreal --version 2>&1", 1)
  end
end
