class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.6.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.4/tribucket-darwin-arm64"
      sha256 "b83f9c12055e7817ea4237ecb52622c46045af0052eb9638dc3f53d6c7a0e64e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.4/tribucket-linux-arm64"
      sha256 "0901278839696cc76990a03a0abafe57e303038a2fdc1a78ecb3d5d70807ed55"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.4/tribucket-linux-amd64"
      sha256 "ed0e730f12570d0aa6cbc743be1c5e2538ba91a0d8614f7237d533f1abb015b4"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
