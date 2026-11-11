class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.67"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.67/CLIProxyAPI_8.0.67_darwin_aarch64.tar.gz"
      sha256 "ea5bc14e874f422b0049ada5bcc0552636340fab0fac791d7dda6af4fe70fccf"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.67/CLIProxyAPI_8.0.67_darwin_amd64.tar.gz"
      sha256 "ca0600e743748afd6103d1fc57be93b59b211fa88d9215e1ff3462ab58ad4214"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.67/CLIProxyAPI_8.0.67_linux_aarch64.tar.gz"
      sha256 "716744c8e41762e4621eea841138be908c0ffbe373a31d5674331def8d700ad7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.67/CLIProxyAPI_8.0.67_linux_amd64.tar.gz"
      sha256 "5edaf5180be7d1aa31a0aaae0fc115d715b43001b7572c69709ed155f3a7d876"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
