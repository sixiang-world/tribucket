class Neovim < Formula
  desc "Hyperextensible Vim-based text editor"
  homepage "https://github.com/neovim/neovim"
  version "0.12.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/neovim/neovim/releases/download/v0.12.3/nvim-macos-arm64.tar.gz"
      sha256 "532da1d00e465a660fa01c3d4991333d09c52107dce7df937368545daca0a14e"
    end
    on_intel do
      url "https://github.com/neovim/neovim/releases/download/v0.12.3/nvim-macos-x86_64.tar.gz"
      sha256 "4b40e318eb7073321fa5fc06d7f60c3c0de1d7ea50ffbaa8b04286f5484d294f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/neovim/neovim/releases/download/v0.12.3/nvim-linux-arm64.tar.gz"
      sha256 "e055af73fa9c72b37456da8d204fa5c09850bc07e80e9176fe3b87d4afb7a3fc"
    end
    on_intel do
      url "https://github.com/neovim/neovim/releases/download/v0.12.3/nvim-linux-x86_64.tar.gz"
      sha256 "c441b547142860bf01bcce39e36cbed185c41112813e15443b16e5237750724d"
    end
  end

  def install
    bin.install Dir["nvim*"].first => "nvim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nvim --version 2>&1", 1)
  end
end
