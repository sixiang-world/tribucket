class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.5/CLIProxyAPI_7.2.5_darwin_aarch64.tar.gz"
      sha256 "4cc0acfeb7afc0c37da33a11a16f9beba0dcb7e201be2d2743a3a65d26704a74"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.5/CLIProxyAPI_7.2.5_darwin_amd64.tar.gz"
      sha256 "0267659307b7b5d162bc79882fc42e89cad0c86556736afc6fb97ea0432b3773"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.5/CLIProxyAPI_7.2.5_linux_aarch64.tar.gz"
      sha256 "6ee1e02f80f41dd92b2bbd4ad7426885dc6b0fc35f269fc0e76d77837d84cd3a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.5/CLIProxyAPI_7.2.5_linux_amd64.tar.gz"
      sha256 "96dc6100507668e4d7760ea58560933b8ec94bd28e2af5f0c9b726f32de639ba"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
