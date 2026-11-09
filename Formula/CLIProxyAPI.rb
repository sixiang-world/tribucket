class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.61"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.61/CLIProxyAPI_8.0.61_darwin_aarch64.tar.gz"
      sha256 "ed73b4e3e9a71c524c54ecb64da3235a48de5f233aabccc58c43259ac6b1392f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.61/CLIProxyAPI_8.0.61_darwin_amd64.tar.gz"
      sha256 "6d60879a83f2a18dc5af37ee93a571c7f524fac9a664cb0b6080ccf11126c6e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.61/CLIProxyAPI_8.0.61_linux_aarch64.tar.gz"
      sha256 "ca1ba77c8140c875c66d5cb470cd6aba421f6ef71fede54e8e34703a46be5731"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.61/CLIProxyAPI_8.0.61_linux_amd64.tar.gz"
      sha256 "9d0af252b7eca7b9f670f15cd0d369b20a3bb14523b474a00b1ea334a2220078"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
