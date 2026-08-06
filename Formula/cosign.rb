class Cosign < Formula
  desc "Container signing, verification, and storage"
  homepage "https://github.com/sigstore/cosign"
  version "3.1.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.3/cosign-darwin-arm64"
      sha256 "5cf948c2f4dfe59687bdd0b8523709067383e03982cc543475c8a7dc70e92a76"
    end
    on_intel do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.3/cosign-darwin-amd64"
      sha256 "2347488e5d5b25336644024dfeca5601b190e91197a71a917bda44744aff106c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.3/cosign-linux-arm64"
      sha256 "c5d324e091826b0d7a78eb16fef316450b4eb9aaec045611c08ba06f5e73220a"
    end
    on_intel do
      url "https://github.com/sigstore/cosign/releases/download/v3.1.3/cosign-linux-amd64"
      sha256 "4629c757b7618056f8ddd7e2625ae9fdd94c0372a65049520bc7d9df9efc7f71"
    end
  end

  def install
    bin.install Dir["cosign*"].first => "cosign"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cosign --version 2>&1", 1)
  end
end
