class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.47"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.47/CLIProxyAPI_7.2.47_darwin_aarch64.tar.gz"
      sha256 "7dcb8a71b18ec8938743d79c149af660cbb70fe676187c8b22331f34d183c4cd"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.47/CLIProxyAPI_7.2.47_darwin_amd64.tar.gz"
      sha256 "2072e6567ac4b22fe7359ac5848a9245da21c6c33d7d6331131d9eaf971d1c2e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.47/CLIProxyAPI_7.2.47_linux_aarch64.tar.gz"
      sha256 "e1a68f76e73628b98a238190875cceed775dce3f8d88ac7fbebbf163a3639ea1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.47/CLIProxyAPI_7.2.47_linux_amd64.tar.gz"
      sha256 "fe1562817b08688a70235595741092acbb1c3976c098f8686cf5a3ff23a2db8a"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
