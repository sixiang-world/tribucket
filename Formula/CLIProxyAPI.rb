class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.80"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.80/CLIProxyAPI_7.2.80_darwin_aarch64.tar.gz"
      sha256 "7b13a17670a7d24318e3d6a3f24ff38696cf23ab44894fc93fbd53fbb68dfda6"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.80/CLIProxyAPI_7.2.80_darwin_amd64.tar.gz"
      sha256 "e442331bf90e908adac1da0b5536c360318dd95708f21423705ed0ae6d311fcc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.80/CLIProxyAPI_7.2.80_linux_aarch64.tar.gz"
      sha256 "c86b709019e6a86ca068772a1ec6f528f314030076163655789f8243be928549"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.80/CLIProxyAPI_7.2.80_linux_amd64.tar.gz"
      sha256 "6c973562831c4ace016b057708ccb6529ba88af93fe67841ed109b81fe030b9a"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
