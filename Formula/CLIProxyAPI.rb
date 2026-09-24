class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.16/CLIProxyAPI_7.3.16_darwin_aarch64.tar.gz"
      sha256 "b6d478cc16c608abfec9343ee97d3a850403604f12e237952bcfdbad2a03e234"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.16/CLIProxyAPI_7.3.16_darwin_amd64.tar.gz"
      sha256 "f5dd942200a05687d2132d572ff63c635f3d7b154f34a5d737dadeddd718b828"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.16/CLIProxyAPI_7.3.16_linux_aarch64.tar.gz"
      sha256 "5af23cdc4c5fc61d260ed6f7cd207fdeee893e174f6866bc5ac6d7d1dddae111"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.16/CLIProxyAPI_7.3.16_linux_amd64.tar.gz"
      sha256 "64f84d7a08570f8e5310707857bc9edfb032292a9753b5f840da6c8caa325a72"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
