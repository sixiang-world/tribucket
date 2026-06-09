class Cosign < Formula
  desc "Container signing, verification, and storage"
  homepage "https://github.com/sigstore/cosign"
  version "3.1.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.1/cosign-darwin-arm64"
      sha256 "94b42a9e697be95675f6160ab031a9a5f1ec1e646d6f648d7b2f5cd59ececbc5"
    end
    on_intel do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.1/cosign-darwin-amd64"
      sha256 "14d2678dfbfde18798151e86fbd91ebdadbb7424b18412a42a155dd8a2df4c7a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.1/cosign-linux-arm64"
      sha256 "2ec865872e331c32fd12b08dae15332d3f92c0aa029219589684a4903ca85d11"
    end
    on_intel do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.1/cosign-linux-amd64"
      sha256 "ae1ecd212663f3693ad9edf8b1a183900c9a52d3155ba6e354237f9a0f6463fc"
    end
  end

  def install
    bin.install Dir["cosign*"].first => "cosign"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cosign --version 2>&1", 1)
  end
end
