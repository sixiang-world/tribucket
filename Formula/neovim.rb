class Neovim < Formula
  desc "Hyperextensible Vim-based text editor"
  homepage "https://github.com/neovim/neovim"
  version "0.12.5"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-macos-arm64.tar.gz"
      sha256 "65fb000099e47ca1b762584c484cc833f40e30851a0ec450d4174e16317c1f9b"
    end
    on_intel do
      url "https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-macos-x86_64.tar.gz"
      sha256 "81f4518622cb059b450ee2e498c6a1082a222f6bd89589de5bbcf0c6a68aa3fd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-arm64.tar.gz"
      sha256 "1aa5ca085249580ae0f91eb14f27ec0919773ff2d99a163d03f3d6c21ac29725"
    end
    on_intel do
      url "https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-x86_64.tar.gz"
      sha256 "bce0f56eda1f1b1db6eee8f4133d7a38813ea07933837dd1777411ca384c6875"
    end
  end

  def install
    bin.install Dir["nvim*"].first => "nvim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nvim --version 2>&1", 1)
  end
end
