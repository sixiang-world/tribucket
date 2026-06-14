class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.62.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.62.2/lazygit_0.62.2_darwin_arm64.tar.gz"
      sha256 "f311d96b666b4865760e39f3967edfd7bf30b5d09e52a1bc7ae511f6bdfdd02c"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.62.2/lazygit_0.62.2_darwin_x86_64.tar.gz"
      sha256 "21c276a94f8ddb55d8336df60d69a5b7509e7434024445b4d51d2a11bd6c76b6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.62.2/lazygit_0.62.2_linux_arm64.tar.gz"
      sha256 "9ab63dd75a7e9711c4c68a37d77f4334b8099a5d6a3f8fbe8f4e2768b159c9e9"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.62.2/lazygit_0.62.2_linux_x86_64.tar.gz"
      sha256 "8b9a4c2d0969cbea92b45c956dd2a44e1ba76900c9df49f1c60984045ce77984"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
