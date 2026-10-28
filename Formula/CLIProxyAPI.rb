class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.46"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.46/CLIProxyAPI_8.0.46_darwin_aarch64.tar.gz"
      sha256 "f9cdb85ccd70602ce084ad0aa8576a057a5e7dd8ff63a64b229cd145c5e6652b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.46/CLIProxyAPI_8.0.46_darwin_amd64.tar.gz"
      sha256 "bf8ba3bd1990e115bfba6f61a93d83233974a5457540ebdd03df69d142f14efb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.46/CLIProxyAPI_8.0.46_linux_aarch64.tar.gz"
      sha256 "07b792e0d2eedb46fcb6c9d1eda913b4c53413076a03199346a85a573fd00de7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.46/CLIProxyAPI_8.0.46_linux_amd64.tar.gz"
      sha256 "471f5235c501c19d3dec85c06e7612f0fe5ce3f823ef75331c2097aad8ed3c62"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
