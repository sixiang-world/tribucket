class Gping < Formula
  desc "Ping with a graph"
  homepage "https://github.com/orf/gping"
  version "gping-v1.21.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/orf/gping/releases/download/gping-v1.21.0/gping-macOS-arm64.tar.gz"
      sha256 "9061a06d93490f97b3a956e149d8ec4c9030625f764e8dbfac9b737c00bd9ea0"
    end
    on_intel do
      url "https://github.com/orf/gping/releases/download/gping-v1.21.0/gping-macOS-x86_64.tar.gz"
      sha256 "d0206c60fb5e7c6a9b727968aec847a3b0eb206f1f763c6c784324288114e732"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/orf/gping/releases/download/gping-v1.21.0/gping-Linux-gnu-arm64.tar.gz"
      sha256 "49af7566b5b3cac2b1692cc0fd12522519a362d9ce3b45daa29ecf6912d9baa6"
    end
    on_intel do
      url "https://github.com/orf/gping/releases/download/gping-v1.21.0/gping-Linux-gnu-x86_64.tar.gz"
      sha256 "965d4246cdc6907957199b3f2732e52e36e37a4162a6d15a86f3d26c223a01ef"
    end
  end

  def install
    bin.install Dir["gping*"].first => "gping"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gping --version 2>&1", 1)
  end
end
