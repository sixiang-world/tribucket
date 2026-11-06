class Opentofu < Formula
  desc "Open-source infrastructure as code tool (Terraform fork)"
  homepage "https://github.com/opentofu/opentofu"
  version "1.13.9"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_darwin_arm64.zip"
      sha256 "29ba2f4c78556a8d25476e5070fe4745495ef649c4a3b827170eb7436d23feb3"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_darwin_amd64.zip"
      sha256 "ac5505dd19d896f327d0ab727d4b853413c694931a7602b31f93c3a3e9d46d00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_linux_arm64.zip"
      sha256 "04f7c93828b859d420269ed30f923ffebf09157b5d7fb95bf8d88a4d208b7fa3"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_linux_amd64.zip"
      sha256 "bc44eb6b06446ba83bd4072114891987f590f66cca712737a7f1147c50c539ce"
    end
  end

  def install
    bin.install Dir["tofu*"].first => "tofu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tofu --version 2>&1", 1)
  end
end
