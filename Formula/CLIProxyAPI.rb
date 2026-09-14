class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.2/CLIProxyAPI_7.3.2_darwin_aarch64.tar.gz"
      sha256 "34376bc5823281668859a7b3e3688bb90eeb267d8f197a247605947a478af4ec"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.2/CLIProxyAPI_7.3.2_darwin_amd64.tar.gz"
      sha256 "975ce91feb82da9ef6a3b4403abe7f0d865fbbabb9ba4e46da5c0e280a8ece1d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.2/CLIProxyAPI_7.3.2_linux_aarch64.tar.gz"
      sha256 "b00c59eb7d11379b1000e080617119a3c96c5eb1b689d660b35ffb262a165415"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.2/CLIProxyAPI_7.3.2_linux_amd64.tar.gz"
      sha256 "0fd47b760612e9896e9500382742deede6f026d6903de707ef9e3316b66ae635"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
