class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.66.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.2/lazygit_0.66.2_darwin_arm64.tar.gz"
      sha256 "fadda59ae7665ba556fcbaa704c7eade6e40d016d3f3b25d6327dd1f3f906a0c"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.2/lazygit_0.66.2_darwin_x86_64.tar.gz"
      sha256 "de5d3771e4befa6fe17590e21445614998adc1ef34a71f4003df6764247517ab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.2/lazygit_0.66.2_linux_arm64.tar.gz"
      sha256 "79a3161eeb642f0473e23db6341f7baabd4a5933e921a9c1167c5d5c765c41a4"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.66.2/lazygit_0.66.2_linux_x86_64.tar.gz"
      sha256 "158efc9ddfa1241fab5fb3526bb442c8dc6c4b1904d73213b9e4e93e03c52034"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
