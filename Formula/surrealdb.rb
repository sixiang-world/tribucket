class Surrealdb < Formula
  desc "Scalable, distributed document-graph database"
  homepage "https://github.com/surrealdb/surrealdb"
  version "4.0.1"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v4.0.1/surreal-v4.0.1.darwin-arm64.tgz"
      sha256 "82ef9da958ccccbf13a7d8574208dbeec2ebf4f8732a510246c8d73ef6e3947d"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v4.0.1/surreal-v4.0.1.darwin-amd64.tgz"
      sha256 "3659503199db7586216742ab1474d0d7202ed5a1e99eff1a7f619580f766397a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v4.0.1/surreal-v4.0.1.linux-arm64.tgz"
      sha256 "52b385d8894a61f650679fea21036f0261c4676e3b8e5a84ecb7e4a46baf8f66"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v4.0.1/surreal-v4.0.1.linux-amd64.tgz"
      sha256 "9d9d26313bf3f1aeffd066def9493932c79053fc9bca8f1b39f83d511f65577d"
    end
  end

  def install
    bin.install Dir["surreal*"].first => "surreal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surreal --version 2>&1", 1)
  end
end
