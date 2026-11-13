class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.69"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.69/CLIProxyAPI_8.0.69_darwin_aarch64.tar.gz"
      sha256 "44070a946dd8932829a52e5d15fe8f01c3748afbbdacc17b10f5a42ce7dba263"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.69/CLIProxyAPI_8.0.69_darwin_amd64.tar.gz"
      sha256 "dc9b9e782cf1266eedb9c7102ade1f263027af2cf509c8175e156b74bda994d6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.69/CLIProxyAPI_8.0.69_linux_aarch64.tar.gz"
      sha256 "19f13e62643ea9f6275553622ad13f945e551397166f099a78c32a2e0f85d4c3"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.69/CLIProxyAPI_8.0.69_linux_amd64.tar.gz"
      sha256 "4213723d57096bc97ad32d810b89653ba3edeb384087cecc90956c4c33e8af22"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
