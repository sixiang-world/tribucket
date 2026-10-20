class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.35"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.35/CLIProxyAPI_8.0.35_darwin_aarch64.tar.gz"
      sha256 "b6903000ae78b541e5ba0bb2db45fc15dc23cab77fb51ed4b02e03ea18fe36a5"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.35/CLIProxyAPI_8.0.35_darwin_amd64.tar.gz"
      sha256 "c1335ddb5307d67684ec0531fac81e1148b68869179310ea0f4086109fbebe2b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.35/CLIProxyAPI_8.0.35_linux_aarch64.tar.gz"
      sha256 "570db8fcf5677cbfa2f32b35e117c4df9d91d5966057f7fe4604fd493033dd83"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.35/CLIProxyAPI_8.0.35_linux_amd64.tar.gz"
      sha256 "1d9edde6973e8f15694debcd186b5ab693e0741bd6a4c5e551aa89e0a6b57e38"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
