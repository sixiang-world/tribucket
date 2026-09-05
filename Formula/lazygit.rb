class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.65.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.65.0/lazygit_0.65.0_darwin_arm64.tar.gz"
      sha256 "d8ea1cade9e4279e45cbb58652e84edb07e98a9f8ec0604099c8b0a8f709e63a"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.65.0/lazygit_0.65.0_darwin_x86_64.tar.gz"
      sha256 "3848033450205f975aa6a587e76f01c9796bff3a3cc0e32060ac77b9423264e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.65.0/lazygit_0.65.0_linux_arm64.tar.gz"
      sha256 "d954a09c128bd37b2bd0d254308474e87de3729cfe0e37f5b46a49357a4fe257"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.65.0/lazygit_0.65.0_linux_x86_64.tar.gz"
      sha256 "44d8e7dd1484b4a66e191bd4ab25a71e8b4b3a65ab122f838e65677ef58c5506"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
