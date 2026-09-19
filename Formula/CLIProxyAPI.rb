class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.9/CLIProxyAPI_7.3.9_darwin_aarch64.tar.gz"
      sha256 "d174fe1612c5ce3d09f2f78c972ca016c5fb1c1222d0c5084dc9359619011656"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.9/CLIProxyAPI_7.3.9_darwin_amd64.tar.gz"
      sha256 "1a956eeb722faed88655887cdb57d73e3477af4fc18e54be259d962aa8e342ee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.9/CLIProxyAPI_7.3.9_linux_aarch64.tar.gz"
      sha256 "827d7b8fb43a137898f7b68ceb6ff1aefcd0528cd5d59ea61317251171832b75"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.9/CLIProxyAPI_7.3.9_linux_amd64.tar.gz"
      sha256 "fd45e915d84e40fc09cefaae6b271a59d542bf284fd3dfee38abe5472412427b"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
