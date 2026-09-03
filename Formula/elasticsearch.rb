class Elasticsearch < Formula
  desc "Distributed search and analytics engine by Elastic"
  homepage "https://www.elastic.co/elasticsearch"
  version "9.5.3"
  license "Elastic-2.0"

  on_macos do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.3-darwin-aarch64.tar.gz"
      sha256 "9ba48bcc28eb6db114a85007c994924d910ef1e53549dc19c42abed6499f4a36"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.3-darwin-x86_64.tar.gz"
      sha256 "b4151c330679dea2da079b997a4993a61de84bab26a3b380e6c35c4e74563c61"
    end
  end

  on_linux do
    on_arm do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.3-linux-aarch64.tar.gz"
      sha256 "5c34bb887a353e0cf4717e367886424501c65d77ca094147961da7c2265aab4a"
    end
    on_intel do
      url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.3-linux-x86_64.tar.gz"
      sha256 "8eacd9dd6c295e02391f4df7b69c73883bc53417af82e2af74c38906038e5362"
    end
  end

  def install
    bin.install Dir["elasticsearch*"].first => "elasticsearch"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elasticsearch --version 2>&1", 1)
  end
end
