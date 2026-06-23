class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.33"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.33/CLIProxyAPI_7.2.33_darwin_aarch64.tar.gz"
      sha256 "3b63d4effc0cc650a95f6f6f08d7d81d638d9b3b4ad414d631f23c3356dd9b46"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.33/CLIProxyAPI_7.2.33_darwin_amd64.tar.gz"
      sha256 "db548763c3549b20fd3a4997f9e0da30ec5a9e76081b5cdadf530e490c589b4c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.33/CLIProxyAPI_7.2.33_linux_aarch64.tar.gz"
      sha256 "dba70fb7cbc299dd4d5e2bcecce4c6a9e0b9e41659f8f84937cd70fd17276350"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.33/CLIProxyAPI_7.2.33_linux_amd64.tar.gz"
      sha256 "d6bd361c4c3afc0a56dfde18c5180cdc651daa07fa5e07a44b61cac46141047d"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
