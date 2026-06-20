class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.22"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.22/CLIProxyAPI_7.2.22_darwin_aarch64.tar.gz"
      sha256 "8577b56d4086aa6d4740333ba94b8ebae576ffeefe5ab9870e07e09712cadff3"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.22/CLIProxyAPI_7.2.22_darwin_amd64.tar.gz"
      sha256 "77812304ff04eb72b4eec6145450c3f90651099353f6c3878557abb2c848d80c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.22/CLIProxyAPI_7.2.22_linux_aarch64.tar.gz"
      sha256 "43770d8bec13dd2c6826bceb94ce0922d6b01b061d5b0251d90d9ca611b62df0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.22/CLIProxyAPI_7.2.22_linux_amd64.tar.gz"
      sha256 "3784d5e6f7b019c4838352025fec98f32ba77bb2c8ef76a2dc31a430f85a9751"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
