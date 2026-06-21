class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.63"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.63/codewhale-macos-arm64"
      sha256 "c5168080e6215785a30b3f213c49d3a79e17287711712bc9ab0b907a25e8318e"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.63/codewhale-macos-x64"
      sha256 "701ba48d26b888f4c15543ea3db93fa2790dc3fab86219f896273df053fdaf7c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.63/codewhale-linux-arm64"
      sha256 "806bf64f8052e0ec9b78a004b4b217db31c56521754bcaa9ef90edcb0d5d18cf"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.63/codewhale-linux-x64"
      sha256 "48c68e507b3d55815fcaed0e1e6534bc5b5418c1591848120dd2d6b74aa667a3"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
