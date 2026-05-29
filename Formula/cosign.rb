class Cosign < Formula
  desc "Container signing, verification, and storage"
  homepage "https://github.com/sigstore/cosign"
  version "3.0.6"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sigstore/cosign/releases/download/v3.0.6/cosign-darwin-arm64"
      sha256 "5fadd012ae6381a6a29ff86a7d39aa873878852f1073fc90b15995961ecfb084"
    end
    on_intel do
      url "https://github.com/sigstore/cosign/releases/download/v3.0.6/cosign-darwin-amd64"
      sha256 "4c3e7af8372d3ca3296e62fa56f23fcbb5721cc6ac1827900d398f110d7cd280"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sigstore/cosign/releases/download/v3.0.6/cosign-linux-arm64"
      sha256 "bedac92e8c3729864e13d4a17048007cfafa79d5deca993a43a90ffe018ef2b8"
    end
    on_intel do
      url "https://github.com/sigstore/cosign/releases/download/v3.0.6/cosign-linux-amd64"
      sha256 "c956e5dfcac53d52bcf058360d579472f0c1d2d9b69f55209e256fe7783f4c74"
    end
  end

  def install
    bin.install Dir["cosign*"].first => "cosign"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cosign --version 2>&1", 1)
  end
end
