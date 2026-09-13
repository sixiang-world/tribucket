class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.65.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.65.1/lazygit_0.65.1_darwin_arm64.tar.gz"
      sha256 "65a367c6ea9a88efebaaf7998a6835eedb987e04916cef677264ff9b31b1b13e"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.65.1/lazygit_0.65.1_darwin_x86_64.tar.gz"
      sha256 "fde13daf583511aa24c42ca154911643231a5af784c7cdd8117264b2fc035b33"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.65.1/lazygit_0.65.1_linux_arm64.tar.gz"
      sha256 "49abecdf6adf4f2dfdb11bf7b9bfada267ea523612ed809d1c6d87f6c04000a7"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.65.1/lazygit_0.65.1_linux_x86_64.tar.gz"
      sha256 "02beacbcda0fa342e50ae3480ba8147307353af3fb28e1d5f790e02329c201a6"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
