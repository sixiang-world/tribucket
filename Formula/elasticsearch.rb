class Elasticsearch < Formula
  desc "Distributed search and analytics engine by Elastic"
  homepage "https://www.elastic.co/elasticsearch"
  version "9.4.2"
  license "Elastic-2.0"

  on_macos do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.2-darwin-aarch64.tar.gz"
      sha256 "5b61ae2c8636cb1fbc9e7ccca2760bfbc50f857e163de4dc9b7042409917994b"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.2-darwin-x86_64.tar.gz"
      sha256 "0fb52596bc39c70383886268d45a14876cc65a4a0e88756c290496a3a5f47cc7"
    end
  end

  on_linux do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.2-linux-aarch64.tar.gz"
      sha256 "09fdd31987ce5b3c15040fbcffa1c0ac9fb863caac09abc11952a8a98509eaf0"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.2-linux-x86_64.tar.gz"
      sha256 "5df80bbbd8d5ba3222552e75c87e7222835c9893820a21326ed2f4f7eec3cfab"
    end
  end

  def install
    bin.install Dir["elasticsearch*"].first => "elasticsearch"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elasticsearch --version 2>&1", 1)
  end
end
