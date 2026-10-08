class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.10.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/codewhale-hq/Codewhale/releases/download/v0.10.1/codewhale-macos-arm64"
      sha256 "e50fdb7dfbb39d7c01eb63175da01bc40f16fb958e01cbcbef03220460302654"
    end
    on_intel do
      url "https://github.com/codewhale-hq/Codewhale/releases/download/v0.10.1/codewhale-macos-x64"
      sha256 "67019fd263cf6b1c8608e1748e368d472346da0ad417ef5b9428a887dfbb9cb1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/codewhale-hq/Codewhale/releases/download/v0.10.1/codewhale-linux-arm64"
      sha256 "efe702a5083fe78a7e09676b129dedba4f595a12b4c824c7f1a794da9ca6d6da"
    end
    on_intel do
      url "https://github.com/codewhale-hq/Codewhale/releases/download/v0.10.1/codewhale-linux-x64"
      sha256 "ed2d83b3853de803ee39f574c745d1e1c9f6f8bf99ed3aec3835425e0c26993b"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
