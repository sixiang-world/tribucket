class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  version "4.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Genymobile/scrcpy/releases/download/v4.1/scrcpy-macos-aarch64-v4.1.tar.gz"
      sha256 "20fd47c9014dd5e0fa77091f3cb7adbda8445a360c4584aeaa0150b5b3988ff3"
    end
    on_intel do
      url "https://github.com/Genymobile/scrcpy/releases/download/v4.1/scrcpy-macos-x86_64-v4.1.tar.gz"
      sha256 "ee2a7223bc8dbdc4f482db1134bcf441178dafb833492b71ca4c22090c58ce72"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Genymobile/scrcpy/releases/download/v4.1/scrcpy-linux-x86_64-v4.1.tar.gz"
      sha256 "ad56ae8bfeedf41e824945c11dbf55fcb092b3e615b9b486f48a50e30d389635"
    end
  end

  def install
    bin.install Dir["scrcpy*"].first => "scrcpy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrcpy --version 2>&1", 1)
  end
end
