class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.10/octopus-darwin-arm64.zip"
      sha256 "ab72b742e8ac19bc28b397739520072e3d7e9e3078b188947061563b04f55300"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.10/octopus-darwin-amd64.zip"
      sha256 "1add59268506abdb373b8deb7470b83be7f7b18809b8726ad71d09fa5f3d8c92"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.10/octopus-linux-arm64.zip"
      sha256 "da772345da629ed1278387538da11a037362c1003a820f4b4e5cef636054b304"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.10/octopus-linux-amd64.zip"
      sha256 "bb82a81ab8d4a6717cd367155793fecfca8e1310984d807e4af5d2c4224b44ae"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
