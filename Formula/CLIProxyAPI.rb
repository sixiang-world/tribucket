class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.60"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.60/CLIProxyAPI_7.1.60_darwin_aarch64.tar.gz"
      sha256 "ee779e6771b72a72cad6e97ffe0c4e85832585bf68050ea427574409806258ac"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.60/CLIProxyAPI_7.1.60_darwin_amd64.tar.gz"
      sha256 "7dc84fb5190f31dd4f2c9147f82ace970922c37fc4e2a149fe0a635864776e7b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.60/CLIProxyAPI_7.1.60_linux_aarch64.tar.gz"
      sha256 "2b369f775b024c826e71ddbb0ef71f2923e906a9d532bce98804f4b5aa2692e3"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.60/CLIProxyAPI_7.1.60_linux_amd64.tar.gz"
      sha256 "12f0aceb22f117a4156dbebeb0145ac748f96f8e8b3bb342de34105c19c56625"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
