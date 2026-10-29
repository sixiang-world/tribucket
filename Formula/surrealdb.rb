class Surrealdb < Formula
  desc "Scalable, distributed document-graph database"
  homepage "https://github.com/surrealdb/surrealdb"
  version "3.3.5"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.5/surreal-v3.3.5.darwin-arm64.tgz"
      sha256 "534140236e7246d86969015ba9ae8dd2f7f8f277ed1412cb17f3d397f95a1090"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.5/surreal-v3.3.5.darwin-amd64.tgz"
      sha256 "a274451b30cf639df3b180b0e82ab8f7c52bc5244fa66aa65155a085f3eb6d31"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.5/surreal-v3.3.5.linux-arm64.tgz"
      sha256 "de945afaf48660a0d7370d7f631dc964a4cceb46b9cfe0c92ede9061df4cc5e6"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.5/surreal-v3.3.5.linux-amd64.tgz"
      sha256 "8f3bc163405085343fc6db9746a8e0cd55503c939802ad2b35a466675a9c09cf"
    end
  end

  def install
    bin.install Dir["surreal*"].first => "surreal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surreal --version 2>&1", 1)
  end
end
