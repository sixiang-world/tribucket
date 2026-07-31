class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.3/codewhale-macos-arm64"
      sha256 "50b6e13f3f1642f0e3944740f8b80ec2d89a7b4e4cea9f8c43ed26b09385cac0"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.3/codewhale-macos-x64"
      sha256 "6e4dc61c9bbab0b7161161eb7e79c8c7937b20e2d619fbba9dffbba2727dc180"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.3/codewhale-linux-arm64"
      sha256 "926f7c731eadaa80ea5f9c3dc018d0910800071cdac08a29c439d9e8ce350f8e"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.3/codewhale-linux-x64"
      sha256 "e012ad7a566810fd9ad96c1008b59434120fdfabb25feee8a6394f9a9133b5dc"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
