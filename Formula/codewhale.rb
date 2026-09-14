class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.9.13/codewhale-macos-arm64"
      sha256 "4b5f2a885ff814cc105b864b012be2fbb12a46a78bf6a85276f661c1bbdcce0a"
    end
    on_intel do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.9.13/codewhale-macos-x64"
      sha256 "b7a45dd329df4de47eed3e20f8743d4a93aaa4817fac642ccad116c98fac006f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.9.13/codewhale-linux-arm64"
      sha256 "0605271d2a343b241232966ec7ca11cf93170289d05a85ad1c513116be77307d"
    end
    on_intel do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.9.13/codewhale-linux-x64"
      sha256 "593ae256756f969ea9f550e8733303abc85cd3ee0dd2c0899f4a76df7103fe7e"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
