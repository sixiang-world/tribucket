class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.156"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.156/CLIProxyAPI_7.2.156_darwin_aarch64.tar.gz"
      sha256 "c41f985edc744a70dc962ec4250889bad02bdd9be816855021d4d0d93ddf4c92"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.156/CLIProxyAPI_7.2.156_darwin_amd64.tar.gz"
      sha256 "fe7c13292219b25f427015ef01e6d98649da1c97a6c4b59a2dbee3e540c2129f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.156/CLIProxyAPI_7.2.156_linux_aarch64.tar.gz"
      sha256 "c570113560838a1c401b566f34ea6f1fa1c00b7699e515fe1a3e82713459b2b2"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.156/CLIProxyAPI_7.2.156_linux_amd64.tar.gz"
      sha256 "2bf0515e70be3255be4bd13edb352febe7a206c2b823a6b49301d6f37ef40c85"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
