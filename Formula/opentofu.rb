class Opentofu < Formula
  desc "Open-source infrastructure as code tool (Terraform fork)"
  homepage "https://github.com/opentofu/opentofu"
  version "1.12.2"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.2/tofu_1.12.2_darwin_arm64.zip"
      sha256 "234d419b13e4c50bb75c61d6349b31e7f7dde407fb5317e9063fd00d3bf15646"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.2/tofu_1.12.2_darwin_amd64.zip"
      sha256 "1027862fc1c098a5307a5addc9a6be33b9bb79e9b4c8aace6b65132def9d5de3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.2/tofu_1.12.2_linux_arm64.zip"
      sha256 "360a2f238c100818851917531f1ead80c1bda960f9f38f965820fa85fd5147a7"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.2/tofu_1.12.2_linux_amd64.zip"
      sha256 "dc0ad16a42b3bfb5f3ceff3dcd5e9cd4c55271fae9f4bfe611749ff8ae6ec23c"
    end
  end

  def install
    bin.install Dir["tofu*"].first => "tofu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tofu --version 2>&1", 1)
  end
end
