class Surrealdb < Formula
  desc "Scalable, distributed document-graph database"
  homepage "https://github.com/surrealdb/surrealdb"
  version "3.2.4"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.2.4/surreal-v3.2.4.darwin-arm64.tgz"
      sha256 "8d703e9c5ed12e509ec7eb9b17385d3cac440077f93980d5c98b57c2d99cbbe8"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.2.4/surreal-v3.2.4.darwin-amd64.tgz"
      sha256 "bcbb5cabf1695cda6a5d0d5866e54f020bd64f7d641abb932d946e2b8dbb0ad7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.2.4/surreal-v3.2.4.linux-arm64.tgz"
      sha256 "64d9f9c6138df768bf04c0d3637d2ca3655022819ae0b1772a0d62f2fb3f5f03"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.2.4/surreal-v3.2.4.linux-amd64.tgz"
      sha256 "aaf9c8d388248db63e10300385c94ec9f85ef4430e79f9569886045d896df369"
    end
  end

  def install
    bin.install Dir["surreal*"].first => "surreal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surreal --version 2>&1", 1)
  end
end
