class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.38"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.38/CLIProxyAPI_7.2.38_darwin_aarch64.tar.gz"
      sha256 "9ebf8b5d04c2e8a9fc080934f1813d387ff932a5294dc64c40a5b6a1355990e2"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.38/CLIProxyAPI_7.2.38_darwin_amd64.tar.gz"
      sha256 "8cc617232e55cb11e085de587d59c7ed41cdbb0434f4972a36b6db85bc431cd0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.38/CLIProxyAPI_7.2.38_linux_aarch64.tar.gz"
      sha256 "b6bc26710f31f76937d97746710fbb6e94b45849fe296f85a7612174ea094943"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.38/CLIProxyAPI_7.2.38_linux_amd64.tar.gz"
      sha256 "55ecd160b1ad3099b7a59736ed229bdc90d43f8c293549ad1adc1671f40a1516"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
