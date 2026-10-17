class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.32"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.32/CLIProxyAPI_8.0.32_darwin_aarch64.tar.gz"
      sha256 "48fe6a391a01e730ee6ebe3f1609ff92578a97a7a9a44579013ca8f3a6d58d51"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.32/CLIProxyAPI_8.0.32_darwin_amd64.tar.gz"
      sha256 "c327f421d995692f6590a752abd449db5e71df61803b7041e4d3bd59cd1e1bd8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.32/CLIProxyAPI_8.0.32_linux_aarch64.tar.gz"
      sha256 "76aac452dd224490ea5ea1ea0224199d7a410f14ef39a087b81893d15c62f363"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.32/CLIProxyAPI_8.0.32_linux_amd64.tar.gz"
      sha256 "082a4a38d9470c070ac85ab2d9c4a2aa51f9a7ee19831c3b811e26fe5b7480a7"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
