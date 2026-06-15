class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.3.0/tribucket-darwin-arm64"
      sha256 "f6de6a2919bb29e741280efc09b85c9ceaeb54cac35070809091859d1a057cad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.3.0/tribucket-linux-arm64"
      sha256 "4705b78ea105655902f53897c7c8b5e38aba7072d4b1ecba78aae9e62d895553"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.3.0/tribucket-linux-amd64"
      sha256 "a22326ce7f8946be3676bc087f7ed78d85dcde0a324a0a852fabd5f74c9f8fef"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
