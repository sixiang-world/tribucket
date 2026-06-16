class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.7.0/tribucket-darwin-arm64"
      sha256 "3338abd39f9a5ba9df28b31ecfc21765494caf40393d7f26fd5b492a72e8157d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.7.0/tribucket-linux-arm64"
      sha256 "30b4e803f32f1b37d11429a7f1d2fe0b2329a7e4ae769f199829599c962b85b8"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.7.0/tribucket-linux-amd64"
      sha256 "feeaa1c218e612f01bdfd01e126d1c7d4fd7413dd6b22c1198c905d474369515"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
