class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.63.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.63.1/lazygit_0.63.1_darwin_arm64.tar.gz"
      sha256 "b963e9d0a1f4649708c594ac6c999cdcd435f8e679e220e78e87c4642badedd6"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.63.1/lazygit_0.63.1_darwin_x86_64.tar.gz"
      sha256 "5cc02389cc189b1146aa330615f0c547996395ca7661e56f946670947e803006"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.63.1/lazygit_0.63.1_linux_arm64.tar.gz"
      sha256 "555dbc9a8efcf2e33bc24e7fbd9463e9fa375e3c5e23cc270763733c38eeae36"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.63.1/lazygit_0.63.1_linux_x86_64.tar.gz"
      sha256 "8e033bc78c8e192dee9510e951f6c9e154289b7198d22c924ed1d0a951b0dac1"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
