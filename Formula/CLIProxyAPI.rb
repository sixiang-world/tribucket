class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.116"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.116/CLIProxyAPI_7.2.116_darwin_aarch64.tar.gz"
      sha256 "8c4763e092efff7b2734b4eff0d967571ca69304c03a2ea9a420ca63c3e7471c"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.116/CLIProxyAPI_7.2.116_darwin_amd64.tar.gz"
      sha256 "b51b96029a93582d97098271659f6dec5487f0465c013e38cba80cd6519bb1e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.116/CLIProxyAPI_7.2.116_linux_aarch64.tar.gz"
      sha256 "3fd38016d1ad7b31c7e065c104b20ab208fdfae7d6b2717ab43543d911199477"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.116/CLIProxyAPI_7.2.116_linux_amd64.tar.gz"
      sha256 "469adcf760936764781687cfc7057f8ca0db3a685d418dd3d9d84cb1910bde3b"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
