class Eza < Formula
  desc "A modern replacement for ls"
  homepage "https://github.com/eza-community/eza"
  version "0.23.4"
  license "MIT"

  on_linux do
    on_arm do
      url "https://github.com/eza-community/eza/releases/download/v0.23.4/eza_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "366e8430225f9955c3dc659b452150c169894833ccfef455e01765e265a3edda"
    end
    on_intel do
      url "https://github.com/eza-community/eza/releases/download/v0.23.4/eza_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0c38665440226cd8bef5d1d4f3bc6ff77c927fb0d68b752739105db7ab5b358d"
    end
  end

  def install
    bin.install Dir["eza*"].first => "eza"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eza --version 2>&1", 1)
  end
end
