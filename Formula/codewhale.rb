class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.55"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.55/codewhale-macos-arm64"
      sha256 "cad29d33c3ed582b02eccffe54075b85e9bed843716e3f40293740e7ffbb7595"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.55/codewhale-macos-x64"
      sha256 "03dc844b5aad3c75463d02a2bb4f68954ca064f6bcc293b644e4193bfb063540"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.55/codewhale-linux-arm64"
      sha256 "17c8526ec3875e7c4c8ceed3cb735b8acec3e497c11455d46a20c8426f9dada0"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.55/codewhale-linux-x64"
      sha256 "8f09f7aca0dd6bb9dfb5a34ba8c5cd83eb6389cb21382e2cd7b4ad7d2c93b845"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
