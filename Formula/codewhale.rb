class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.52"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.52/codewhale-macos-arm64"
      sha256 "438bbda0a7e398f2b5cdb4c7bb5d1bed645d6429b959e24e0981be0e7b2f64e5"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.52/codewhale-macos-x64"
      sha256 "d2ada816c11f9e97a065e66bf9154e6f9537ddfaa60868113c16f66906a4d8e4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.52/codewhale-linux-arm64"
      sha256 "1b610e746cc80c6b8caf3e62d3893fc8a6e7fcb98a05d95ae6b0b839bfe28bb0"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.52/codewhale-linux-x64"
      sha256 "9f47132906c588edc2365352c6be30b0c2ffdb8bf384e3ce08714c146c1dfc33"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
