class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.51"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.51/codewhale-macos-arm64"
      sha256 "7655176c1df1b846ff484b23e26480f4d545aecf74114930d2a4125c9d9ddb92"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.51/codewhale-macos-x64"
      sha256 "bceb091bdb88f4730f722d22305d0a6c7f625a2e0c761080eea4abea87c15d16"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.51/codewhale-linux-arm64"
      sha256 "2604fb797824856638b6720e48afe2b69ced5209b31aa1f563b6ce556492d1fa"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.51/codewhale-linux-x64"
      sha256 "cfd0c6d40c524aead3e01f2918c54ba197770abd57accc98aac4475fbf5a0cdb"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
