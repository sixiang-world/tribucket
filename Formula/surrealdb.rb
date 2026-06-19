class Surrealdb < Formula
  desc "Scalable, distributed document-graph database"
  homepage "https://github.com/surrealdb/surrealdb"
  version "3.1.5"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.1.5/surreal-v3.1.5.darwin-arm64.tgz"
      sha256 "476152bf16b974e13c9f8b6c78b8f91f605c7421cf7b221067399180fcb9394a"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.1.5/surreal-v3.1.5.darwin-amd64.tgz"
      sha256 "dfc9ce907ac61a8fea0c758c6639cbb72aee4511f375a572d7e3bed081d61d22"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.1.5/surreal-v3.1.5.linux-arm64.tgz"
      sha256 "a39dfa845b1db9777d70c2ebad2de0b6637eda66e0bb1808aaee1362855345b1"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.1.5/surreal-v3.1.5.linux-amd64.tgz"
      sha256 "f7d515203ba0010bde3fc6a5706ce7327d356aca293fbba8424d442f5dcb5002"
    end
  end

  def install
    bin.install Dir["surreal*"].first => "surreal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surreal --version 2>&1", 1)
  end
end
