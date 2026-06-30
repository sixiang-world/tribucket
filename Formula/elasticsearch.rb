class Elasticsearch < Formula
  desc "Distributed search and analytics engine by Elastic"
  homepage "https://www.elastic.co/elasticsearch"
  version "9.4.3"
  license "Elastic-2.0"

  on_macos do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.3-darwin-aarch64.tar.gz"
      sha256 "845aac3507c35e4930177e7524796219bee58efd357a7c6228c4c49eab2baa06"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.3-darwin-x86_64.tar.gz"
      sha256 "b328bdcb6e3d2245452e4a60365e123e6c29dcd9f74486d4bacbe2e9dbd2bbee"
    end
  end

  on_linux do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.3-linux-aarch64.tar.gz"
      sha256 "73dca64a35bad6e02fbeff642b2266006b6ba905fce16d51136c8d3ff5cddc70"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.3-linux-x86_64.tar.gz"
      sha256 "0a08c880eb41b657b0e853c416070af358bf398e5097ea481e9a5317fff4ed4e"
    end
  end

  def install
    bin.install Dir["elasticsearch*"].first => "elasticsearch"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elasticsearch --version 2>&1", 1)
  end
end
