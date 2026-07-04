class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.63.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.63.0/lazygit_0.63.0_darwin_arm64.tar.gz"
      sha256 "60e6bf29a1501a57a9d078538aa576a1b4db45779db2e3dd6931a7207f560a9c"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.63.0/lazygit_0.63.0_darwin_x86_64.tar.gz"
      sha256 "304b1bf7f7bbb5a5d59e34145bce63d42733cd828e4fe41428ced9ee4dbfe942"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.63.0/lazygit_0.63.0_linux_arm64.tar.gz"
      sha256 "aac147abf5ce43afe6ae8bcb14b0d479111975a189302d7a99386deca70d57f7"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.63.0/lazygit_0.63.0_linux_x86_64.tar.gz"
      sha256 "cf5cfa3e116d7775f3600a51ec1d9ce7ba554a08b9566c7c2da83cb0023efabf"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
