class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.23"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.23/CLIProxyAPI_8.0.23_darwin_aarch64.tar.gz"
      sha256 "3c056b42ec4c80d06a74d3c5abf47ae0adb06285e32f5cf31a29bdd07017feb3"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.23/CLIProxyAPI_8.0.23_darwin_amd64.tar.gz"
      sha256 "bfa737b927cd7680ca78a4126c2e09edd1ed510c18605123cf15f2dbae47d896"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.23/CLIProxyAPI_8.0.23_linux_aarch64.tar.gz"
      sha256 "7c54c9306167b3e252090924c39a9b9dd5c09dffd376551271d8902f391f0246"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.23/CLIProxyAPI_8.0.23_linux_amd64.tar.gz"
      sha256 "744000a1a4f9ce19f5964774f853d029797b87ef53796d054389258c66cb1224"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
