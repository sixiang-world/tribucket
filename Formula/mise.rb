class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.6/mise-v2026.10.6-macos-arm64.tar.gz"
      sha256 "6c6a0b26b15b7dabec9fe61a56f53e1bf5dfa5246da9f59fa8028eef2ec238cb"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.6/mise-v2026.10.6-macos-x64.tar.gz"
      sha256 "37a9a96f31f08082cd4a978a284ad52562eabe3898e401205d72dc7b11d850f5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.6/mise-v2026.10.6-linux-arm64.tar.gz"
      sha256 "60f0e34ea2088e822797393ed3d3b50d58dd9b45687006b31ac66ef68e99a2f4"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.6/mise-v2026.10.6-linux-x64.tar.gz"
      sha256 "5135da6b71e6857efb22b2eb8d0fbc0061d061005a4994f1e7f8975d548a3e92"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
