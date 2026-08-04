class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.64.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.64.0/lazygit_0.64.0_darwin_arm64.tar.gz"
      sha256 "df8d2dd27cdc1075785f1abb85b74fe393fcdc1f3fdf6cb2b587feb3ce72ba33"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.64.0/lazygit_0.64.0_darwin_x86_64.tar.gz"
      sha256 "164d003f2eaa73e898d218882ec1eb9af517d3f3a351dff736390fc649e1b838"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.64.0/lazygit_0.64.0_linux_arm64.tar.gz"
      sha256 "d286487eb18b2b82fccfd0f1c55d8445e6eb82c08ced3b9eb3e5be0e7c627fd0"
    end
    on_intel do
      url "https://github.com/jesseduffield/lazygit/releases/download/v0.64.0/lazygit_0.64.0_linux_x86_64.tar.gz"
      sha256 "7996236f2c1dd2643d96c3d67a1f7fcd2560bf08bcb7f6be073e26fb29167ac6"
    end
  end

  def install
    bin.install Dir["lazygit*"].first => "lazygit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit --version 2>&1", 1)
  end
end
