class Elasticsearch < Formula
  desc "Distributed search and analytics engine by Elastic"
  homepage "https://www.elastic.co/elasticsearch"
  version "9.5.1"
  license "Elastic-2.0"

  on_macos do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.1-darwin-aarch64.tar.gz"
      sha256 "1aaaded8216021b8c064a87a50d767fd2d58015f35382632834a7534998c0134"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.1-darwin-x86_64.tar.gz"
      sha256 "0a66ded48b29871046110638a8946dcd76cbc38b53cd1697867ece74755a48b6"
    end
  end

  on_linux do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.1-linux-aarch64.tar.gz"
      sha256 "dc4b0a589f2d34ca9e974d743d032174cb94a52752fa9f626ca81ad38720bdd5"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.1-linux-x86_64.tar.gz"
      sha256 "8cbb7eb64179430f4b267965c3cc1f32b12ff0eca3e0fbf04450ddd67c3b478b"
    end
  end

  def install
    bin.install Dir["elasticsearch*"].first => "elasticsearch"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elasticsearch --version 2>&1", 1)
  end
end
