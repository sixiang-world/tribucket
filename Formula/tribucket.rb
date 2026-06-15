class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.2.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.3/tribucket-darwin-arm64"
      sha256 "a1bf26fec2112f1cd5502f63a2ef4da0c1ca8b4bc593bf33b70ea03414265b70"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.3/tribucket-linux-arm64"
      sha256 "33abe311d5002700812f6faed8bbf410c8d4bf01e3c871ad33b7bf7bc1140be3"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.3/tribucket-linux-amd64"
      sha256 "7bef9467c3a1a09df4bf4eb0270e564f0292b73967eddffce72b9a0a03d31ec4"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
