class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.66.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.1/lazygit_0.66.1_darwin_arm64.tar.gz"
      sha256 "c66b15f666216142a2f39143f5540c6a572473f03fab014dae07c33cd76e719a"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.1/lazygit_0.66.1_darwin_x86_64.tar.gz"
      sha256 "525aa969eac201ee74c51a1aa52af0891d3d945a3f444f14d399252da31f3986"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.1/lazygit_0.66.1_linux_arm64.tar.gz"
      sha256 "add91327af13343f37d2d610512d0982ef5c75da5cc962b5159748adc8a11a86"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.1/lazygit_0.66.1_linux_x86_64.tar.gz"
      sha256 "7b3f30c2c06a42cf575280f907e58d7ea08411408b6b62bc926bc91cbc6c3f46"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
