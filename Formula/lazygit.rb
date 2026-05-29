class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.62.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.62.1/lazygit_0.62.1_darwin_arm64.tar.gz"
      sha256 "878697eb72157915f5bff4d4a40f7ea896f096b308190a1a1b20fe17576cfd0d"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.62.1/lazygit_0.62.1_darwin_x86_64.tar.gz"
      sha256 "33963e544085e0a820b71837fa4c8db82d6ab409ffd03a5677898b766541c537"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.62.1/lazygit_0.62.1_linux_arm64.tar.gz"
      sha256 "22a19e4790323dfe0363a876d1f76738ee9722a3086ef27c9e4503c3c1d962ac"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.62.1/lazygit_0.62.1_linux_x86_64.tar.gz"
      sha256 "99d78cce8883b24150c2f4ba151f6a0443644f63f63794f18d6643e99f75be09"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
