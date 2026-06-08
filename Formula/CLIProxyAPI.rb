class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.55"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.55/CLIProxyAPI_7.1.55_darwin_aarch64.tar.gz"
      sha256 "809272320ca0749d8c1744742ed95f552bcdb909b29b7eb5feca60d94f2b0216"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.55/CLIProxyAPI_7.1.55_darwin_amd64.tar.gz"
      sha256 "2b43f85fe128ab1823fd063596f571abd7b7170be932b8d125ed02a3d65250f2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.55/CLIProxyAPI_7.1.55_linux_aarch64.tar.gz"
      sha256 "19989481408d00fdfb9a81e249b5106b4503530ab9162fafdd200a6270eb8d8e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.55/CLIProxyAPI_7.1.55_linux_amd64.tar.gz"
      sha256 "a7a7c4db98ddfa21ad427bde22129d367bce61f6006e96059415afda1ad778e6"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
