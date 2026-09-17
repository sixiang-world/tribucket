class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.5/CLIProxyAPI_7.3.5_darwin_aarch64.tar.gz"
      sha256 "c9c31467b0b00f12809c8ef064463f48359a727bd6c5fe4349482149822f8bad"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.5/CLIProxyAPI_7.3.5_darwin_amd64.tar.gz"
      sha256 "06ca6b553796b4e540e4f559841d91c77a4e28fed72e7016536191b18fc8f4d8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.5/CLIProxyAPI_7.3.5_linux_aarch64.tar.gz"
      sha256 "49e905fc746cf1db2904ff0de52d14c52bde395e173b7a3d61f11224b62febc0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.5/CLIProxyAPI_7.3.5_linux_amd64.tar.gz"
      sha256 "d8ea443f95977fda52d6b86c4f07dbd3fb448ca05574212951ec3c42b903f407"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
