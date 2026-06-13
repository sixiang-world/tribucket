class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.74"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.74/CLIProxyAPI_7.1.74_darwin_aarch64.tar.gz"
      sha256 "8d9e5e55f7341dab8fb87314ed9030b5bbb5f0bbea10dfb955032660d7fe9ead"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.74/CLIProxyAPI_7.1.74_darwin_amd64.tar.gz"
      sha256 "d4324e1457be398a59648b8937acb74a2767c92ee47ac37187ec70d5391cfb0d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.74/CLIProxyAPI_7.1.74_linux_aarch64.tar.gz"
      sha256 "5336154cc2050cfa37719679cce705b8fb5de815e82906414a7404236067c1e0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.74/CLIProxyAPI_7.1.74_linux_amd64.tar.gz"
      sha256 "9b24d701084e781ebbc942489ee87dc038468e960e1ce7934a4f49fdaf1bfb2b"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
