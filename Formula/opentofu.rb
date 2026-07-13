class Opentofu < Formula
  desc "Open-source infrastructure as code tool (Terraform fork)"
  homepage "https://github.com/opentofu/opentofu"
  version "1.12.4"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.4/tofu_1.12.4_darwin_arm64.zip"
      sha256 "e5e8db9c2dd2c657a8b46931e41cd8dd1d89e5a30aebd742f4f8eafcf1815a35"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.4/tofu_1.12.4_darwin_amd64.zip"
      sha256 "ff4d49559157697b4e3651868aead7ce0e85744242e1b60679f29d6ddc777a45"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.4/tofu_1.12.4_linux_arm64.zip"
      sha256 "a3b01db857c7c650768ffa8ad9119dc2db82fe1b98125b7238392a160aca7f8a"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.4/tofu_1.12.4_linux_amd64.zip"
      sha256 "f5d2ae8a0efcddd3722546b3e0f2f2f0648ce5e5a3e411176041adcb7dccc1e8"
    end
  end

  def install
    bin.install Dir["tofu*"].first => "tofu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tofu --version 2>&1", 1)
  end
end
