class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  version "5.0.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Genymobile/scrcpy/releases/download/v5.0.1/scrcpy-macos-aarch64-v5.0.1.tar.gz"
      sha256 "33611e51977a8289e2e124b220f727895181ef2eb9060e0987a4dc2db9cf0d6b"
    end
    on_intel do
      url "https://github.com/Genymobile/scrcpy/releases/download/v5.0.1/scrcpy-macos-x86_64-v5.0.1.tar.gz"
      sha256 "31a5467a9e907f162b093267cbbab1276b15c6e709c2ea8159566a8d165beb50"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Genymobile/scrcpy/releases/download/v5.0.1/scrcpy-linux-x86_64-v5.0.1.tar.gz"
      sha256 "9f969d30cc574816077edecda65719c1c70b0aee1df1ba5fa00779ac07b8fd6e"
    end
  end

  def install
    bin.install Dir["scrcpy*"].first => "scrcpy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrcpy --version 2>&1", 1)
  end
end
