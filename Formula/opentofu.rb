class Opentofu < Formula
  desc "Open-source infrastructure as code tool (Terraform fork)"
  homepage "https://github.com/opentofu/opentofu"
  version "1.13.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.0/tofu_1.13.0_darwin_arm64.zip"
      sha256 "6e03dc4d12df57c0f7da38cb963f28e8d0418eb6f0762a2fc5eb3988da6b396d"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.0/tofu_1.13.0_darwin_amd64.zip"
      sha256 "c4eea55d524073fc90244a035fb2c31a3f108bcedf16e7f449f0831e772d3287"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.0/tofu_1.13.0_linux_arm64.zip"
      sha256 "34dfd5c6d7de0372789d92dc0db52a9c710edac7cc2abef404a76a1fae6f2ef8"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.0/tofu_1.13.0_linux_amd64.zip"
      sha256 "ad494034a03aaa66d93fc1c2c164d01bedf21b44cfb8b616182cb69424a67672"
    end
  end

  def install
    bin.install Dir["tofu*"].first => "tofu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tofu --version 2>&1", 1)
  end
end
