class Gping < Formula
  desc "Ping with a graph"
  homepage "https://github.com/orf/gping"
  version "gping-v1.20.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.1/gping-macOS-arm64.tar.gz"
      sha256 "3cbfdd3653853cb4770542af7a9f259ddf93c08c507883320e4a00dfaaabca2b"
    end
    on_intel do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.1/gping-macOS-x86_64.tar.gz"
      sha256 "5c1a7273788f5c9e47650ade9181cd5fc3bcf1978269e0826132af3b9bc69fd0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.1/gping-Linux-gnu-arm64.tar.gz"
      sha256 "d8a46c8e4d66367f1d56c731698784d0fe812bac3e1ec5cef9555ab15e1497d5"
    end
    on_intel do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.1/gping-Linux-gnu-x86_64.tar.gz"
      sha256 "793a27f578e86d5358ec67fb82a1251741cd3a8ce576ccc9589891380e6c72b0"
    end
  end

  def install
    bin.install Dir["gping*"].first => "gping"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gping --version 2>&1", 1)
  end
end
