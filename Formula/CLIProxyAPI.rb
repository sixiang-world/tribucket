class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.36"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.36/CLIProxyAPI_7.2.36_darwin_aarch64.tar.gz"
      sha256 "80653d9de436feb5ec2d1466a3a0ddc3160e50b66908ffeca3d6736c98325a01"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.36/CLIProxyAPI_7.2.36_darwin_amd64.tar.gz"
      sha256 "72b5c5bee645071a7fea52748a877b5d08b15849e78da6d2349ac41c5418f937"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.36/CLIProxyAPI_7.2.36_linux_aarch64.tar.gz"
      sha256 "c93534f3e6fab73f2ce3151dc09ac29139d98bd8884e32d484e5ae15c5188e21"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.36/CLIProxyAPI_7.2.36_linux_amd64.tar.gz"
      sha256 "82ad7c28c9b0ea627bcfc154350fcbfda7b0acaab8e18035569cb47c6c3f433f"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
