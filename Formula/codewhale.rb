class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.8/codewhale-macos-arm64"
      sha256 "5fc3f01d3c412ba00475b16e4a60695c54e5b1f11f4ef1918d5b97835f7516ad"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.8/codewhale-macos-x64"
      sha256 "61cae935b41ca4e49607969f469ca0eeb6d7983533bbe5054b7d7f5c8c44e0cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.8/codewhale-linux-arm64"
      sha256 "af4f0c917a49056c5965addc74369cbfd6f9cd276197f028f6fd9301425c5db4"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.8/codewhale-linux-x64"
      sha256 "f3a035de438b5904e9f032d330990987bbd19843ae1cb5c1e37d8b1b782ec1ea"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
