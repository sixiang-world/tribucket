class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.6/codewhale-macos-arm64"
      sha256 "32fea86fcd7cf4e444fe1dd5e876debdffed564a4514fe84d644a01165f545ed"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.6/codewhale-macos-x64"
      sha256 "fd38ffff8a4d51a3377cae04ca73bcb42cb5c2f6f901a00a0f539c874a6fca0c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.6/codewhale-linux-arm64"
      sha256 "2bb3dc897faf660354911e675f83add27001e1991fc1bb740bac1b1393bb3e3c"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.6/codewhale-linux-x64"
      sha256 "3f8610f8d4c283fffdd38a9a4bd041b512a7e3cadf859d9b25ad097b50eab7e6"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
