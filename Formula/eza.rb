class Eza < Formula
  desc "A modern replacement for ls"
  homepage "https://github.com/eza-community/eza"
  version "0.23.5"
  license "MIT"

  on_linux do
    on_arm do
      url "https://github.com/eza-community/eza/releases/download/v0.23.5/eza_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "40b87ae8628aa2ff0f0d2dc24ab52f689631366385c3da630bae745671fd71ec"
    end
    on_intel do
      url "https://github.com/eza-community/eza/releases/download/v0.23.5/eza_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "35c70c5c43c29108075e58b893234c67ef585f0b53a7eaf8e9e7d4eec9f339b4"
    end
  end

  def install
    bin.install Dir["eza*"].first => "eza"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eza --version 2>&1", 1)
  end
end
