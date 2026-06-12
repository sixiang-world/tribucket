class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.71"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.71/CLIProxyAPI_7.1.71_darwin_aarch64.tar.gz"
      sha256 "bce9c508c15b205ceb8c6a26adf8eb3c20fbbdd5cba167debe6fd8d6983a46b3"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.71/CLIProxyAPI_7.1.71_darwin_amd64.tar.gz"
      sha256 "638d1791cced198c24509b4934951462999cab6ea39300c7ea67a8efb4d4b774"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.71/CLIProxyAPI_7.1.71_linux_aarch64.tar.gz"
      sha256 "c18acf82ef2d2e602c58c711d2bcf4ff589beba40741772b6df8be824f374b43"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.71/CLIProxyAPI_7.1.71_linux_amd64.tar.gz"
      sha256 "9386f683de870f3bc8f4f69831ad60c397cf63b19d32421a143b3eddd185e9bb"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
