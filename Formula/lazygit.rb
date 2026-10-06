class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.66.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.0/lazygit_0.66.0_darwin_arm64.tar.gz"
      sha256 "e9fe2fe1f1bbc1b4c3214b33e8e0d57a4d6e3c2276aa9aa713f9bcbdc223e65c"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.0/lazygit_0.66.0_darwin_x86_64.tar.gz"
      sha256 "2b621118f03b8249f0cc6bed378e25bf679e0ef1c97ceed01f92814f5a91a576"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.0/lazygit_0.66.0_linux_arm64.tar.gz"
      sha256 "9a4fc4656897ac9f7877b835473ce1a75620cc267f554c57fc4ff266407f3257"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.0/lazygit_0.66.0_linux_x86_64.tar.gz"
      sha256 "5b45541155d20bd32bf2cc5ab5b7e3d91c2eebf0fb1242281350edc27d59d2b7"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
