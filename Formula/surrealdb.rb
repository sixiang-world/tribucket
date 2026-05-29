class Surrealdb < Formula
  desc "Scalable, distributed document-graph database"
  homepage "https://github.com/surrealdb/surrealdb"
  version "3.0.5"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.0.5/surreal-v3.0.5.darwin-arm64.tgz"
      sha256 "76655a2b42097f66133a0d1affda6c67dbc1454923da14d71f78c73fa0f69d17"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.0.5/surreal-v3.0.5.darwin-amd64.tgz"
      sha256 "1377f8b97b9aefe70109f6f6af5f7c8f371b59878aaba9e5cff81c02afc6c685"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.0.5/surreal-v3.0.5.linux-arm64.tgz"
      sha256 "86837a439a549ba35f78f463857ae74f0aa08b49bb473ca0fa09a122eaa6374e"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.0.5/surreal-v3.0.5.linux-amd64.tgz"
      sha256 "48dbeba4896765f33e07acc25224073f0850c190872052b917ebda1f7b4375cb"
    end
  end

  def install
    bin.install Dir["surreal*"].first => "surreal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surreal --version 2>&1", 1)
  end
end
