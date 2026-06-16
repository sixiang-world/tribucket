class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.12/CLIProxyAPI_7.2.12_darwin_aarch64.tar.gz"
      sha256 "fad3038a7d5497777986dda757e53df1d5e7f7512a95ed7d52024bf2ba36dc18"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.12/CLIProxyAPI_7.2.12_darwin_amd64.tar.gz"
      sha256 "72962e3657bd3ea868677c71fa9987a3da788f4388b48c935acc7642a2da2aea"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.12/CLIProxyAPI_7.2.12_linux_aarch64.tar.gz"
      sha256 "a82e110bd1149923c7412f10a42165374f3a99cd3d91f7399a0b981c3a5dd696"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.12/CLIProxyAPI_7.2.12_linux_amd64.tar.gz"
      sha256 "3f1f17a5bb394f9e61ba8c0afc9191405de12d5faa3d731a1aabe4916c08e378"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
