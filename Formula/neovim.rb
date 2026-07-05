class Neovim < Formula
  desc "Hyperextensible Vim-based text editor"
  homepage "https://github.com/neovim/neovim"
  version "0.12.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-macos-arm64.tar.gz"
      sha256 "51ab83afa66d663627c2ab1be43209b0f4e81360d4598b53efaa4d8195f24c89"
    end
    on_intel do
      url "https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-macos-x86_64.tar.gz"
      sha256 "03fe16f8dd9f1e9eaf52d5e294913a39917b9e2faea30d7fb0fb385fbd36fe59"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-linux-arm64.tar.gz"
      sha256 "ceb7e88c6b681f0515d135dcdfad54f5eb4373b25ce6172197cd9a69c758063f"
    end
    on_intel do
      url "https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-linux-x86_64.tar.gz"
      sha256 "012bf3fcac5ade43914df3f174668bf64d05e049a4f032a388c027b1ebd78628"
    end
  end

  def install
    bin.install Dir["nvim*"].first => "nvim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nvim --version 2>&1", 1)
  end
end
