class Surrealdb < Formula
  desc "Scalable, distributed document-graph database"
  homepage "https://github.com/surrealdb/surrealdb"
  version "3.3.4"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.4/surreal-v3.3.4.darwin-arm64.tgz"
      sha256 "d0b0afc47948a46ceac9db178d2a10a7eb21e1c4f219a74b3573c850122ed9fb"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.4/surreal-v3.3.4.darwin-amd64.tgz"
      sha256 "0723b555340da2cee1e0cff6f95552438536eab8d984b91f227b3ce2d52a5006"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.4/surreal-v3.3.4.linux-arm64.tgz"
      sha256 "978262fd9d1f3adfc5791031663855baf0a3cf8a89883428109734ba5a065811"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.4/surreal-v3.3.4.linux-amd64.tgz"
      sha256 "6593071833ad9c85cf533cf70b1643eb08966c868f8624001e30839ea29a2689"
    end
  end

  def install
    bin.install Dir["surreal*"].first => "surreal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surreal --version 2>&1", 1)
  end
end
