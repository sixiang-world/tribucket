class Opentofu < Formula
  desc "Open-source infrastructure as code tool (Terraform fork)"
  homepage "https://github.com/opentofu/opentofu"
  version "1.13.1"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.1/tofu_1.13.1_darwin_arm64.zip"
      sha256 "81aebe6453223bcb3ce3c28424b36d009ebfddd3ad65ad1ec3eed0d0d574a77b"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.1/tofu_1.13.1_darwin_amd64.zip"
      sha256 "d44ab59ec53fb18e900f4ae3fc8b72e042c9e03ca957860edbaac04e4427218d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.1/tofu_1.13.1_linux_arm64.zip"
      sha256 "b9614df40575cc3fc10a8a25025b7245d961da279f715ea3efff4ddae8e6938a"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.1/tofu_1.13.1_linux_amd64.zip"
      sha256 "8ccbc6f8ee21d2827715f3c6e08a9b3e0209b1e62057c05067ef117e047c1a80"
    end
  end

  def install
    bin.install Dir["tofu*"].first => "tofu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tofu --version 2>&1", 1)
  end
end
