class Surrealdb < Formula
  desc "Scalable, distributed document-graph database"
  homepage "https://github.com/surrealdb/surrealdb"
  version "3.3.0"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.0/surreal-v3.3.0.darwin-arm64.tgz"
      sha256 "75e37adf5f9aacfa1308df71193b2d0e0727bc6532105541c083e71271cd7fc9"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.0/surreal-v3.3.0.darwin-amd64.tgz"
      sha256 "c8e560d37c9f6f04b95f22791723122b5579f1fa5ac5102d6d82c36e38b72710"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.0/surreal-v3.3.0.linux-arm64.tgz"
      sha256 "f03356497f875057126641f06757671542e0a7b75f18fd13820c2dab29349d74"
    end
    on_intel do
      url "https://github.com/surrealdb/surrealdb/releases/download/v3.3.0/surreal-v3.3.0.linux-amd64.tgz"
      sha256 "44aeab565f7e7e39d2d0bf0583c8aae648babc91373c70b2658288d95bbbcd55"
    end
  end

  def install
    bin.install Dir["surreal*"].first => "surreal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surreal --version 2>&1", 1)
  end
end
