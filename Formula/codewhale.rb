class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.50"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.50/codewhale-macos-arm64"
      sha256 "3f7c124c686791bbe9a57ab9ae4bc88699ab0f4b82855c4f6cb3c699d279c781"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.50/codewhale-macos-x64"
      sha256 "e8811f83444e75a7f8480b51a94e80e70213fdc26e91ca4c8ff3ab61fe2dd558"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.50/codewhale-linux-arm64"
      sha256 "6abf21de137a13c363d7d9d5bf3264708a4370f30189e60ae67b50e587143aae"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.50/codewhale-linux-x64"
      sha256 "d6f91a95e1710b2003cccdc61f2e861c39ba831d5828c2bbd707eeac51408485"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
