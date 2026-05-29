class Opentofu < Formula
  desc "Open-source infrastructure as code tool (Terraform fork)"
  homepage "https://github.com/opentofu/opentofu"
  version "1.12.1"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.1/tofu_1.12.1_darwin_arm64.zip"
      sha256 "06cff265b39c437ba81f91cfa85ae91b6ae28d3112bb2273294431a3f54e8bf5"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.1/tofu_1.12.1_darwin_amd64.zip"
      sha256 "bc1bf25272976a568831889b42c4dddad5897c348e5ecc63960a732feee8a73f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.1/tofu_1.12.1_linux_arm64.zip"
      sha256 "1a53dd57697dc04d243ddb81a0f70e44ab83c256f15dde173e5538120dc6a0bb"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.1/tofu_1.12.1_linux_amd64.zip"
      sha256 "1fc9af962e3632b7cd0ba27076cd9f1ced177567defe9e331ac37f5a40468575"
    end
  end

  def install
    bin.install Dir["tofu*"].first => "tofu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tofu --version 2>&1", 1)
  end
end
