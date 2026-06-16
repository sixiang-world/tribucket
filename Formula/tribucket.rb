class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.6.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.8/tribucket-darwin-arm64"
      sha256 "d4184a02d4ba6a5c4079bb33fc0ec4281bd001facf9be1ec569832ba4bcecc8e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.8/tribucket-linux-arm64"
      sha256 "5ae1eb45a1cb4809bc5fe3cf73381fc8735c3dbea13adc9aa95c6389a1e7e1a1"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.8/tribucket-linux-amd64"
      sha256 "30c73d7c95ee8993ed4f6943a7e3d1cac3af11896ed29517adf4124bc197643a"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
