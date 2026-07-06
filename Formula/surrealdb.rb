class Surrealdb < Formula
  desc "Scalable, distributed document-graph database"
  homepage "https://github.com/surrealdb/surrealdb"
  version "3.2.0"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.2.0/surreal-v3.2.0.darwin-arm64.tgz"
      sha256 "a05a25be3fdeb3839cf7ce74fb85f9867851952001e9ad2b461a2d3fd84e8fe8"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.2.0/surreal-v3.2.0.darwin-amd64.tgz"
      sha256 "71e2622454b317c53b92508d7fbab8d45e5e336e9ecd5f4aee2cad3edf0db198"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.2.0/surreal-v3.2.0.linux-arm64.tgz"
      sha256 "8dc83157d74d906e573d80b0c33c6fb80185ceb58c9553ea1768b8d7b4c7703c"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.2.0/surreal-v3.2.0.linux-amd64.tgz"
      sha256 "9c0a9ae29444f3b144a1261fc923116b0e10a3cbadc478cabc9009b3beb9bb3a"
    end
  end

  def install
    bin.install Dir["surreal*"].first => "surreal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surreal --version 2>&1", 1)
  end
end
