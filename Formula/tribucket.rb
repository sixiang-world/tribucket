class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.6.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.1/tribucket-darwin-arm64"
      sha256 "4bdc1a56b9bd47645536df1c8d3127445b11fda83df249d5072b3203f80d3065"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.1/tribucket-linux-arm64"
      sha256 "5abc8420f993cdd30015b202fe299889fda70d1731017c99e4cbc13c35813192"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.1/tribucket-linux-amd64"
      sha256 "9bef69eea159f53f31c589254598ea9e52245702537699066982fc93268f2955"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
