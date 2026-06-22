class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.64"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.64/codewhale-macos-arm64"
      sha256 "4d562270131af71cc002ca29cd86038cd7b5faa23cea721e9f615693d65cfb25"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.64/codewhale-macos-x64"
      sha256 "7cf56ae4574503e874d82bcc662c41e60af7db17e8c2e0aa68699cb4912e4e35"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.64/codewhale-linux-arm64"
      sha256 "818a1f08b1d0d8341be7851f4ffb46d29d85138d42599f05ef56fae684063639"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.64/codewhale-linux-x64"
      sha256 "b0abc99bac494832198cdee25ecab904c6b2ec09b89a2be1cd6998a2ba60ed76"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
