class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.43"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.43/CLIProxyAPI_7.2.43_darwin_aarch64.tar.gz"
      sha256 "318f0825cb8a1c71bb110738a70f94b136b8cfec6f3b9d6618680675ec6a5545"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.43/CLIProxyAPI_7.2.43_darwin_amd64.tar.gz"
      sha256 "783c25bee69fe09b7710c6d6b660a6af20bd3ff63b636eff755bc8f85d69627d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.43/CLIProxyAPI_7.2.43_linux_aarch64.tar.gz"
      sha256 "baee0e9197576a756a8907c7e77c7b7dadf9d7e9f7e4aa547d85afa80befaea0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.43/CLIProxyAPI_7.2.43_linux_amd64.tar.gz"
      sha256 "361b46f4c46977c7c6a323010ad5add7be95a2c9bf88894eedff970e19987944"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
