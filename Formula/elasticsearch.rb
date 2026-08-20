class Elasticsearch < Formula
  desc "Distributed search and analytics engine by Elastic"
  homepage "https://www.elastic.co/elasticsearch"
  version "9.5.2"
  license "Elastic-2.0"

  on_macos do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.2-darwin-aarch64.tar.gz"
      sha256 "282960b75ab441edf8a5ad5ec85e16846ce0fd3792721c7565cbdd8356eb7c40"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.2-darwin-x86_64.tar.gz"
      sha256 "0d228b75ece7914b3d7e4e632a4cb2c24589549f43e7bc9ed6d8faf0465f5a91"
    end
  end

  on_linux do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.2-linux-aarch64.tar.gz"
      sha256 "4b2b0238fd919b9180da6190a9826fb84cdfc7510f39d60c948cb01cba2f7c1a"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.2-linux-x86_64.tar.gz"
      sha256 "11c6a44af6fb3853970c96eb16cf0c69a3a846fbbd7bfb1c7ceb2c32d78e36c4"
    end
  end

  def install
    bin.install Dir["elasticsearch*"].first => "elasticsearch"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elasticsearch --version 2>&1", 1)
  end
end
