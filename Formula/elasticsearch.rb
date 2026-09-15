class Elasticsearch < Formula
  desc "Distributed search and analytics engine by Elastic"
  homepage "https://www.elastic.co/elasticsearch"
  version "9.5.4"
  license "Elastic-2.0"

  on_macos do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.4-darwin-aarch64.tar.gz"
      sha256 "88762e3ef4e860d64106e83f8e48786fc44062726a20465dd67cd1431de6ab3d"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.4-darwin-x86_64.tar.gz"
      sha256 "3a1b1e7597926e0782aac931cdb0d7285ae2e5b3da2539415ed95ce90a2de4da"
    end
  end

  on_linux do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.4-linux-aarch64.tar.gz"
      sha256 "20df6f6dbd0d6b21e2c6213200c074a993f7803efb24bd0bb2614387368e04b1"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.4-linux-x86_64.tar.gz"
      sha256 "098c788e6cecc2fb48555bc9d3ff5ad23613707ad539605c8f4f83abe1851726"
    end
  end

  def install
    bin.install Dir["elasticsearch*"].first => "elasticsearch"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elasticsearch --version 2>&1", 1)
  end
end
