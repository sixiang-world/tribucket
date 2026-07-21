class Opentofu < Formula
  desc "Open-source infrastructure as code tool (Terraform fork)"
  homepage "https://github.com/opentofu/opentofu"
  version "1.12.5"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.5/tofu_1.12.5_darwin_arm64.zip"
      sha256 "dbb5a5bae9b0cabf622cd81a80ea02230eae8a3813215400df41a2cb89b47157"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.5/tofu_1.12.5_darwin_amd64.zip"
      sha256 "45ab896c37c9e2b461604d3fd162867e825bef85b2c2c4c5443b28dc5fb51bd4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.5/tofu_1.12.5_linux_arm64.zip"
      sha256 "528f4eea63452bbddb30fa4f1780b57fac8d7676f9dda0f772e847bb62c1260a"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.5/tofu_1.12.5_linux_amd64.zip"
      sha256 "dade9650e6b74fc7a8b986bd8717497d32f9e09cf82e479afef4977fa3085536"
    end
  end

  def install
    bin.install Dir["tofu*"].first => "tofu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tofu --version 2>&1", 1)
  end
end
