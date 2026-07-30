class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.2/codewhale-macos-arm64"
      sha256 "dcb6fbe81993ae57d2e0f06c25e2ce8252d3f87e5aab311de7413af893be5b6c"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.2/codewhale-macos-x64"
      sha256 "fe5714b56e073c1914a05db72f676ef0367e19e22e106c4ca5caa5fdc0d2cce1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.2/codewhale-linux-arm64"
      sha256 "caedb1a28ca232d584431958313785f3fd5e0472e2512778114d29554ec239ff"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.2/codewhale-linux-x64"
      sha256 "43ca1ceb477f8208b3a45698258e227879f546855269fef946aeeb356ccc6b26"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
