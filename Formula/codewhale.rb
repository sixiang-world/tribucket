class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.10/codewhale-macos-arm64"
      sha256 "3403e8bc2b128eeff1d9f150cab99ab20523252d83b6822201540bd14d06604e"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.10/codewhale-macos-x64"
      sha256 "8dd44a65ab102b487197682f4a04337f7362a023a16674357544f21c7c35f7f7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.10/codewhale-linux-arm64"
      sha256 "23dd8dbbd8abcff4c8fe46b756b02cbfd558987e1397146470ceb09ee5c59b22"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.10/codewhale-linux-x64"
      sha256 "ed02522881d503dfa3b21dcb943c1320862c3a347ab573b170f1d82f91f1014b"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
