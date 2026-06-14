class Surrealdb < Formula
  desc "Scalable, distributed document-graph database"
  homepage "https://github.com/surrealdb/surrealdb"
  version "3.1.4"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.1.4/surreal-v3.1.4.darwin-arm64.tgz"
      sha256 "a5cd2def542cad710581c5ca6f03f0c67fc640e96c790b10ae850ed781d5b39c"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.1.4/surreal-v3.1.4.darwin-amd64.tgz"
      sha256 "bed4ac044ae09e9768db8320bd80d8762e64640f27ce91ed05300117b3b5be47"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.1.4/surreal-v3.1.4.linux-arm64.tgz"
      sha256 "4c2f634b1a5e276b6d24e4f19bf8e5068a0760572ffec0536c3970165c2444d3"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.1.4/surreal-v3.1.4.linux-amd64.tgz"
      sha256 "ff27994d8024dd35b8e862ca754eb2b478e3929cfcfbe17637f98a5efa5cbdb8"
    end
  end

  def install
    bin.install Dir["surreal*"].first => "surreal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surreal --version 2>&1", 1)
  end
end
