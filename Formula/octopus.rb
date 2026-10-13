class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.11/octopus-darwin-arm64.zip"
      sha256 "c471d510599a120cd1875d9af58a0df1e8cdd9735f600b1d0caa79f22e18a6d5"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.11/octopus-darwin-amd64.zip"
      sha256 "eb51c6e7c244423ea7fad163bd202f4af25e076dde98168ce292a487f348a6fc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.11/octopus-linux-arm64.zip"
      sha256 "6b41c414d940741bb873f876e2e1dd57eee4481d670fc6dcc67dc45021b64d57"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.11/octopus-linux-amd64.zip"
      sha256 "11f1ba4eab3c5fe626fee1829dc2a4ee4453b11f71b76b962d8c6ca215683464"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
