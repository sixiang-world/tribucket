class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.120"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.120/CLIProxyAPI_7.2.120_darwin_aarch64.tar.gz"
      sha256 "01ebcb3a683560c91f532fb124ac30edcc68945859e3ddf4880e09f1979ffdee"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.120/CLIProxyAPI_7.2.120_darwin_amd64.tar.gz"
      sha256 "1f2dd819f3176d5ad85ad089d8aafff3214182a6135957ce6c938ad3273bd737"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.120/CLIProxyAPI_7.2.120_linux_aarch64.tar.gz"
      sha256 "5ba28b842b9add6388b77b1672fd0ec9904ca1814c896b507ddebe5df42b4ec9"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.120/CLIProxyAPI_7.2.120_linux_amd64.tar.gz"
      sha256 "8933332737338be5d5cedae4b96254b9afc8dfe0f13c4322738c65fd7931ce0a"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
