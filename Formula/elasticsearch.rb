class Elasticsearch < Formula
  desc "Distributed search and analytics engine by Elastic"
  homepage "https://www.elastic.co/elasticsearch"
  version "8.17.6"
  license "Elastic-2.0"

  on_macos do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.6-darwin-aarch64.tar.gz"
      sha256 "ec9f04aa7db85e62c5bc10393a9f704847f0b617c332b979a9709fb9215d2ae3"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.6-darwin-x86_64.tar.gz"
      sha256 "ed1377cb55e9e0879c089a2d2123d092f5bb40ab6bd5e87bdce7309c28a6173f"
    end
  end

  on_linux do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.6-linux-aarch64.tar.gz"
      sha256 "dabb299c6845c3e8ded89bcb9a0bec87bb9bf4acc5a3d04699e07bee02fc397e"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.6-linux-x86_64.tar.gz"
      sha256 "878827cffa4cc1ad40eebe6b1e6f9ace111d20557aabee05fba2d4a68d7815e3"
    end
  end

  def install
    bin.install Dir["elasticsearch*"].first => "elasticsearch"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elasticsearch --version 2>&1", 1)
  end
end
