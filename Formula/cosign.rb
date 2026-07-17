class Cosign < Formula
  desc "Container signing, verification, and storage"
  homepage "https://github.com/sigstore/cosign"
  version "3.1.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.2/cosign-darwin-arm64"
      sha256 "dec1c3f802320b19c2fbcf2dc7bcfb3f258e1c181a046c23a1a074bdf932f10a"
    end
    on_intel do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.2/cosign-darwin-amd64"
      sha256 "acd180f8b015be25240ca33abee8a1e564eb65cdf1a3cee4725456d2dceb7da6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.2/cosign-linux-arm64"
      sha256 "90e7ae0b5dfd60f20816b52c012addf7fc055ebcc7bea4ce81c428ca8518c302"
    end
    on_intel do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.2/cosign-linux-amd64"
      sha256 "f7622ed3cf22e55e1ae6377c080979ff77a22da9981c11df222a2e444991e7cf"
    end
  end

  def install
    bin.install Dir["cosign*"].first => "cosign"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cosign --version 2>&1", 1)
  end
end
