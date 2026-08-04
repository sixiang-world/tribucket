class Elasticsearch < Formula
  desc "Distributed search and analytics engine by Elastic"
  homepage "https://www.elastic.co/elasticsearch"
  version "9.5.0"
  license "Elastic-2.0"

  on_macos do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.0-darwin-aarch64.tar.gz"
      sha256 "ab798bb299957eec0f28d2124731a728e2d54ea6d74aab3fbbab4506a85a0cb7"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.0-darwin-x86_64.tar.gz"
      sha256 "29227a1213420e1d24e5a704dfccba281927a518223659375ac604f3a3229b9b"
    end
  end

  on_linux do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.0-linux-aarch64.tar.gz"
      sha256 "b2928bba25ef367ce9b860ee876ff5e843423013f595f7ca88f38ddd5aecf386"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.0-linux-x86_64.tar.gz"
      sha256 "563d75d37b430b6b8f5bf78637bff13a4533c72b2397c2200ecdebeaa4505472"
    end
  end

  def install
    bin.install Dir["elasticsearch*"].first => "elasticsearch"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elasticsearch --version 2>&1", 1)
  end
end
