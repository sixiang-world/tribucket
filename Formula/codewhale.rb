class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.54"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.54/codewhale-macos-arm64"
      sha256 "e09f193d5b11f001f4e063be3263ebea9a5b2063a059df04251b1dbffcf9bafd"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.54/codewhale-macos-x64"
      sha256 "740b45f7f63e97c4a824a247d5189c66a3cf9ed05f6f433c245e00a7c34ed8fe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.54/codewhale-linux-arm64"
      sha256 "5b4da0d1a77242dcea140f5359866e2786b8e306349b46f56ac7b7f4d9458266"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.54/codewhale-linux-x64"
      sha256 "5b42cc7d68e67fa32e87ae600b308534d79b71ca3d7a141b63e07cd6980abe5b"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
