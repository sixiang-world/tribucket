class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.61"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.61/CLIProxyAPI_7.2.61_darwin_aarch64.tar.gz"
      sha256 "6777ddbd8f49e716fb2367cf8930a403824765ccc893cdef60c56898015b33b2"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.61/CLIProxyAPI_7.2.61_darwin_amd64.tar.gz"
      sha256 "5c3c3fac0a7ec62a7272c1c017c59202ff244b6a4a15872924d34629c3f2eb00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.61/CLIProxyAPI_7.2.61_linux_aarch64.tar.gz"
      sha256 "e7b1e79859625be3e0420292b0d8d342d6370b1c0c050ab205901ff8aef2b4af"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.61/CLIProxyAPI_7.2.61_linux_amd64.tar.gz"
      sha256 "ff7a3b2a5148e8b3cc3a57c9cc36d2749ce00b8c96747fb6f672672b1101a888"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
