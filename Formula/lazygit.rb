class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.64.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.64.1/lazygit_0.64.1_darwin_arm64.tar.gz"
      sha256 "a106b4c1bf8ab7539c4afb40a01cbde263a96513cdcb8bf7630278f07e88cd99"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.64.1/lazygit_0.64.1_darwin_x86_64.tar.gz"
      sha256 "f727fdf2efa46f78d102639eafe085cef437928da1e9ec79ec8e203b8a12f2a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.64.1/lazygit_0.64.1_linux_arm64.tar.gz"
      sha256 "8b7ca3b344e60340ad1f89f29b9868ee39bcaba5bb92ee818bbe65476bb8b6e7"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.64.1/lazygit_0.64.1_linux_x86_64.tar.gz"
      sha256 "f8ea237c41f194cd799b48505518bfdaae4edf5a2ad6bd3d898e939785ee4532"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
