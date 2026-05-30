class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.9.28"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.9.28/octopus-darwin-arm64.zip"
      sha256 "1ee77d174d2a1b1651acfd53ce3a42db6a7c112c32e55ca0e6fad8edec9ff3d8"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.9.28/octopus-darwin-x86_64.zip"
      sha256 "33321e0dca2c76c4ef8609ceb61aa2333e7c8bcb84929c1a0962346356b9ba50"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.9.28/octopus-linux-arm64.zip"
      sha256 "908ed6e5cfeb49288ed7615b9987c0b6f4999563bfee0fd691d9c816599c1139"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.9.28/octopus-linux-x86_64.zip"
      sha256 "9288ff2d0a85b673e1c58278c99a76603f314f61699f4f5c1b740102a8367c80"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
