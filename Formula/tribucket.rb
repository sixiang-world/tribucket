class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.5.0/tribucket-darwin-arm64"
      sha256 "113526a65b69ac0cbf5682e657c5a9a032f5cf44abc8c1b4b5ae73116f556152"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.5.0/tribucket-linux-arm64"
      sha256 "d369466e24bdc65c9b48271f3703d04190a425512caa67ab0d5bffdf3006b011"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.5.0/tribucket-linux-amd64"
      sha256 "68fb7a6aa5149943b31a7478ee8144040ec7f0cf2ba07c1072682996e7ef4aef"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
