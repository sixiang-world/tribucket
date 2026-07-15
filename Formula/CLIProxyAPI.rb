class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.77"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.77/CLIProxyAPI_7.2.77_darwin_aarch64.tar.gz"
      sha256 "a7c265f86895bb9d946ad28e3a126a502096dc91afb7e9838477aa4d39e84554"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.77/CLIProxyAPI_7.2.77_darwin_amd64.tar.gz"
      sha256 "6ff8fad7afaaf0f952d24ac9fb1df790eab62a64ea90981386cbbbdfbc3e9c37"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.77/CLIProxyAPI_7.2.77_linux_aarch64.tar.gz"
      sha256 "42fffb0ce6b8ebb897520d4fe80541371ef861658f2ff5acfe1c815aace5c4f3"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.77/CLIProxyAPI_7.2.77_linux_amd64.tar.gz"
      sha256 "dc0814cd0fc33f472ea4f3d5587447e14ffcb34853edac9a523edc1c5d7ba860"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
