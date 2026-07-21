class Elasticsearch < Formula
  desc "Distributed search and analytics engine by Elastic"
  homepage "https://www.elastic.co/elasticsearch"
  version "9.4.4"
  license "Elastic-2.0"

  on_macos do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.4-darwin-aarch64.tar.gz"
      sha256 "83d9b43f5b5901c28048ddf3ce383537d9ee5cb592f84a9fc40f6b2b58fc9e1a"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.4-darwin-x86_64.tar.gz"
      sha256 "5ed3a3b547aad393e0027dd5ad944af93e4a1042a58c361b93b5c082b2bd237f"
    end
  end

  on_linux do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.4-linux-aarch64.tar.gz"
      sha256 "85a0e2e385fabc03660ca14559b2fd85114a461daa04ad11074bffdbc1979ad2"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.4.4-linux-x86_64.tar.gz"
      sha256 "dcf6c79f7bee98577fe61db71aa67cf1daf419ef579a33dc49f1145ad37aeece"
    end
  end

  def install
    bin.install Dir["elasticsearch*"].first => "elasticsearch"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elasticsearch --version 2>&1", 1)
  end
end
