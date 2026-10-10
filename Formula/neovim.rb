class Neovim < Formula
  desc "Hyperextensible Vim-based text editor"
  homepage "https://github.com/neovim/neovim"
  version "0.12.6"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-macos-arm64.tar.gz"
      sha256 "1dbd148222b051ba6c307c4d17a318ed083df018a4f6a5a0ce46955ffc9ab87b"
    end
    on_intel do
      url "https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-macos-x86_64.tar.gz"
      sha256 "481424f1dbc85f637d57e47d27d042aa9c883e5a4fe9ee64fc4ee9573b221998"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-linux-arm64.tar.gz"
      sha256 "8f1f64a0bdb97247034038c3823c6cbad5bdf9ecd5751b85494b71c3ee04c815"
    end
    on_intel do
      url "https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-linux-x86_64.tar.gz"
      sha256 "474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87"
    end
  end

  def install
    bin.install Dir["nvim*"].first => "nvim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nvim --version 2>&1", 1)
  end
end
