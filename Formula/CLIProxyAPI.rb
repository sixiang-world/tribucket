class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.15/CLIProxyAPI_8.0.15_darwin_aarch64.tar.gz"
      sha256 "90fe6d309613b33520b9f08746829dd6c4fdfbbbb353f41ac01e4e94f168f7c4"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.15/CLIProxyAPI_8.0.15_darwin_amd64.tar.gz"
      sha256 "d0f69a00d9ab3a514a96159542dec6632dbfef03e74dc9f8224b7edad9b5ca6f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.15/CLIProxyAPI_8.0.15_linux_aarch64.tar.gz"
      sha256 "172f1f71dc0381538c09f44a65c687b55035c61ff63f505a6b7edd4fc7b69c95"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.15/CLIProxyAPI_8.0.15_linux_amd64.tar.gz"
      sha256 "3acca2d978ba140b4b664bcfb74acea8f6c9a32c24fa6e2d58130f6c1128d3a8"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
