class Cosign < Formula
  desc "Container signing, verification, and storage"
  homepage "https://github.com/sigstore/cosign"
  version "3.1.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.4/cosign-darwin-arm64"
      sha256 "9f9b8cd557cf2e5b3df3373a00baa005a86b02391e3e06dd0ce37b3a1533d3a4"
    end
    on_intel do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.4/cosign-darwin-amd64"
      sha256 "9d1e4abe2b6be279ed0d2ff706fde1ccd738747c834e3e6d44039c238867334f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.4/cosign-linux-arm64"
      sha256 "ade83b7aac62e131cacfe96d958948b2150cc9efec46a570a2649b8e27dedad2"
    end
    on_intel do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.4/cosign-linux-amd64"
      sha256 "424e2c97d0b45fd7a6b608a87f090f35633f4c23ece5f092d48bba11aaf4bbfa"
    end
  end

  def install
    bin.install Dir["cosign*"].first => "cosign"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cosign --version 2>&1", 1)
  end
end
