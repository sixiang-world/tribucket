class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.127"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.127/CLIProxyAPI_7.2.127_darwin_aarch64.tar.gz"
      sha256 "028f6bb2ca014227329fef459923fcc5ced9b69c6f338b78317b0b5f79df4ad0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.127/CLIProxyAPI_7.2.127_darwin_amd64.tar.gz"
      sha256 "3a0586d9f3089aab9a5af36e499a0322c3f76eb94949a6c88ec169f7f3fb8804"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.127/CLIProxyAPI_7.2.127_linux_aarch64.tar.gz"
      sha256 "dc85946d87365cc7469278173bae832b075e9e06493cbcb0737fafda0e20bfe5"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.127/CLIProxyAPI_7.2.127_linux_amd64.tar.gz"
      sha256 "c826fd26012f946e8901668b45bceda379fb5fce5a0bbc9d437e9cdbf2437131"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
