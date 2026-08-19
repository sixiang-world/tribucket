class Opentofu < Formula
  desc "Open-source infrastructure as code tool (Terraform fork)"
  homepage "https://github.com/opentofu/opentofu"
  version "1.12.6"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.6/tofu_1.12.6_darwin_arm64.zip"
      sha256 "e083ee43790ab9e19ad66d9933e24a7244a1412e1d5728f37999ae2163fdac95"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.6/tofu_1.12.6_darwin_amd64.zip"
      sha256 "166388e5feed47e107e11721b6366bf91d21e47eccbced75f3cbe0c7184ffd9b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.6/tofu_1.12.6_linux_arm64.zip"
      sha256 "e573979ba68a17fe7b881752051a694a7efcd970e39521f6a25775197861ed4d"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.6/tofu_1.12.6_linux_amd64.zip"
      sha256 "5dc43da4f750f33873dc25e94587128709e819e544b7be9016b255316153c3a8"
    end
  end

  def install
    bin.install Dir["tofu*"].first => "tofu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tofu --version 2>&1", 1)
  end
end
