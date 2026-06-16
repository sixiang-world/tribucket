class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.7/CLIProxyAPI_7.2.7_darwin_aarch64.tar.gz"
      sha256 "a3e066fe2bd6b9923de72a8778159088f357d847d81ef422b51835b947227aa1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.7/CLIProxyAPI_7.2.7_darwin_amd64.tar.gz"
      sha256 "dff4949ffedcec956efec25f2128bcacb885029929113004ba1c9750f2283c96"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.7/CLIProxyAPI_7.2.7_linux_aarch64.tar.gz"
      sha256 "0caf533d3e22d92323c61fe6bab6a4f833af060c7d9c19df2772c485b60864d4"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.7/CLIProxyAPI_7.2.7_linux_amd64.tar.gz"
      sha256 "3d0f3390d78eb9f894bce280088c8fef9ec2e508a04819f736f052e16f749990"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
