class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.74"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.74/CLIProxyAPI_7.2.74_darwin_aarch64.tar.gz"
      sha256 "a3322962f0885a32b503eda6fec59e963a50543aa4e51d2167484b9f38d47886"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.74/CLIProxyAPI_7.2.74_darwin_amd64.tar.gz"
      sha256 "129e2ec6138021e505157d1fed31133326ebc8001062f2adcd40a5dd687bf02a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.74/CLIProxyAPI_7.2.74_linux_aarch64.tar.gz"
      sha256 "c3e347c62b3b91fc50c1da7569ff5aac2c14ca4fb0a69c629e7aace837748ff7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.74/CLIProxyAPI_7.2.74_linux_amd64.tar.gz"
      sha256 "6952a3b7daa858bfba40008970d6ec46e79f85429043beeef15caf74fe45a010"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
