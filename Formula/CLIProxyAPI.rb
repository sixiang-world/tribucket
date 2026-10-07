class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.19"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.19/CLIProxyAPI_8.0.19_darwin_aarch64.tar.gz"
      sha256 "8a9fc500062271fb61abece837099a7e1c419fbfff3f6bd554a03edcabce3a8e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.19/CLIProxyAPI_8.0.19_darwin_amd64.tar.gz"
      sha256 "7424082c2a89a109d9a3d66bdd146667d921d5b6551f9d46f4fb9cccc11b5043"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.19/CLIProxyAPI_8.0.19_linux_aarch64.tar.gz"
      sha256 "6ba8b00e3f74da197d2d40da38f3975c3ff8007888935e22b991cfd24d90e766"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.19/CLIProxyAPI_8.0.19_linux_amd64.tar.gz"
      sha256 "bfb7425d0128f3fa4cf556dfe7a51dec430a743046fb49cf7a3de5d2e8699867"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
