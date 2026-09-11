class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.158"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.158/CLIProxyAPI_7.2.158_darwin_aarch64.tar.gz"
      sha256 "ac8b4cc36294a88fc1ef631de03b097bef6713d8172b66630ac2727e90faf58b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.158/CLIProxyAPI_7.2.158_darwin_amd64.tar.gz"
      sha256 "e7648e73efcecd4eedb6f1dc45d777537594bc0ecece15dd49932b594593fca3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.158/CLIProxyAPI_7.2.158_linux_aarch64.tar.gz"
      sha256 "ed268dd7520559d58b820c8f418aa3469237331cd03d1236e2f2e2a09b539914"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.158/CLIProxyAPI_7.2.158_linux_amd64.tar.gz"
      sha256 "fe8d8a62c2464289e6fc10595bbb9595fbc4978f2abbf75854d052b91ecacb34"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
