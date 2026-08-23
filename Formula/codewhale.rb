class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.11/codewhale-macos-arm64"
      sha256 "6a1082bb9a8994e547a86fab613eb47177996141d81d25b34c0e9d1ceeabd2cd"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.11/codewhale-macos-x64"
      sha256 "652f02820bf642236dbf12986eb355ead16ddae916dbfd292b24d731cbdd4c12"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.11/codewhale-linux-arm64"
      sha256 "60a14551e994747a4f4ddb779b9c21c6d75aa3e7fdf84515543748450aa48f18"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.11/codewhale-linux-x64"
      sha256 "c02969556e51e138afa3fe9c97a1359878cd3d1986b1ce1f5fa96c93c6909416"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
