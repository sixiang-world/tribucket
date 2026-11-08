class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.66.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.3/lazygit_0.66.3_darwin_arm64.tar.gz"
      sha256 "6873e6b7a538b521c4d7ff3f76ec49e6dcafa41e6053a6aae33c12f62663e163"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.3/lazygit_0.66.3_darwin_x86_64.tar.gz"
      sha256 "f6c116c09b960842351e3e142cc8be1784de611f19d09920421bd7639cccd30b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.3/lazygit_0.66.3_linux_arm64.tar.gz"
      sha256 "ac0b48237f3d0283813e7154ec063237e519532feb0470c0881a1793ee78fd42"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.3/lazygit_0.66.3_linux_x86_64.tar.gz"
      sha256 "0a23f429a95f0d09db298b3c291536d818de066aa5a85c255806f0490ff6656b"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
