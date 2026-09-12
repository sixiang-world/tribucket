class Zola < Formula
  desc "A fast static site generator in a single binary with everything built-in"
  homepage "https://github.com/getzola/zola"
  version "0.23.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.5/zola-v0.23.5-aarch64-apple-darwin.tar.gz"
      sha256 "8c83a33271ab5e7009cf1841cc022819c8c7109d4d61f439f25d8f6508c8b09c"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.5/zola-v0.23.5-x86_64-apple-darwin.tar.gz"
      sha256 "bd63b0af0dd22c246e845c520a3bad8675096a70410574cf794c556be4340c06"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.5/zola-v0.23.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3e61af6cf2a2072a2397f3be7121b5032b46c6ec93bf46d154c8e72abc104c49"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.5/zola-v0.23.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f9b864c54fb8ef598ae34337d72a0e9f24e84a0b051657a7f231a3f2a3c02e34"
    end
  end

  def install
    bin.install Dir["zola*"].first => "zola"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zola --version 2>&1", 1)
  end
end
