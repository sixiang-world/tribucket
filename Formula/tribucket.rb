class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.0.1/tribucket-darwin-arm64"
      sha256 "48ab8d12937128680d7a5c8aabebc41552fa9316672cd38a1f53609909f88c39"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.0.1/tribucket-linux-arm64"
      sha256 "cc3dcdd6926f87e82fac146393d60294b40913cbe3b38677070ebc321df754b3"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.0.1/tribucket-linux-amd64"
      sha256 "590584734a4b8dbcd99ac282003fd5dc7c35b18a851765344ef4423b86287912"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
