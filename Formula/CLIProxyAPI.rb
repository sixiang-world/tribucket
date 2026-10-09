class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.22"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.22/CLIProxyAPI_8.0.22_darwin_aarch64.tar.gz"
      sha256 "2ccb94b03ce4feefa2b839f7a0eaae90951d4131572c075099f56c94d15a7f50"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.22/CLIProxyAPI_8.0.22_darwin_amd64.tar.gz"
      sha256 "53dfa8d458e224c926314aff437f06524731af9f880844ee79b40c8fece86d65"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.22/CLIProxyAPI_8.0.22_linux_aarch64.tar.gz"
      sha256 "ac4f29e368b56738700446a3e613194af910a3cbba2ae645a11c3ecb00752f43"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.22/CLIProxyAPI_8.0.22_linux_amd64.tar.gz"
      sha256 "b1bc3e14bd242c4b35518a9e90906eb5b93892b17516af807376ba06e1882142"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
