class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.64"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.64/CLIProxyAPI_8.0.64_darwin_aarch64.tar.gz"
      sha256 "c3dc41458cf5a2835f833b2c74517d4de78d95f8a8d2b5367bdea95cb631e5aa"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.64/CLIProxyAPI_8.0.64_darwin_amd64.tar.gz"
      sha256 "7803a41dac91459956ffdb7e5e8546b4ef2325e77c85d39f82865848f1196a74"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.64/CLIProxyAPI_8.0.64_linux_aarch64.tar.gz"
      sha256 "6d03cd535942a02ab99eacfe43a90ef8a3fdfacf2d1b82d1a7116abde61afb13"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.64/CLIProxyAPI_8.0.64_linux_amd64.tar.gz"
      sha256 "e793bb469d79f8a08ffb661eed82dc069c32f9fc4e738f6258656f4d84af1b05"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
