class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.31"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.31/CLIProxyAPI_7.2.31_darwin_aarch64.tar.gz"
      sha256 "fad1882475af80c0baf779e91da78996c110d0db58f7b25f4d88b2b46d06a808"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.31/CLIProxyAPI_7.2.31_darwin_amd64.tar.gz"
      sha256 "cb8fec4a18b15fc118eaba43bf8cdbcaa802c87438ad9d67dd4aae73e7ae5872"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.31/CLIProxyAPI_7.2.31_linux_aarch64.tar.gz"
      sha256 "940449d63cee582774f28443314ad5c331cee994009b6c200b963894ac47012b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.31/CLIProxyAPI_7.2.31_linux_amd64.tar.gz"
      sha256 "adf62ca5eddc63ef2f2b9d9d729a648904aba0b6f8e7118b22254b4df4e910f7"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
