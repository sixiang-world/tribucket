class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.50"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.50/CLIProxyAPI_7.1.50_darwin_aarch64.tar.gz"
      sha256 "bf5027f5673d91998e12e04d835c0a439efcc038227fd21b644d46a157bcf47b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.50/CLIProxyAPI_7.1.50_darwin_amd64.tar.gz"
      sha256 "5f591ed5497af0bdeae0d92580821d7fd5f11a42c746d2113a3f4b00a8fc7777"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.50/CLIProxyAPI_7.1.50_linux_aarch64.tar.gz"
      sha256 "4a0ddab4cb0a2b9e514dea8e826fa2190773c3554d1466f817d48602f3cdae11"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.50/CLIProxyAPI_7.1.50_linux_amd64.tar.gz"
      sha256 "a45366f51834bdcf7c6e561ec0b9b2bf5518091bd107c3889e7e7088c722ef04"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
