class Opentofu < Formula
  desc "Open-source infrastructure as code tool (Terraform fork)"
  homepage "https://github.com/opentofu/opentofu"
  version "1.13.8"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.8/tofu_1.13.8_darwin_arm64.zip"
      sha256 "7cd554aa1dd196ea87d5b009edeed0138ef2e21ff8154f829ef71b4f7421806d"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.8/tofu_1.13.8_darwin_amd64.zip"
      sha256 "325e929c2ac4a8fb2077a7d52ad9a3fa8c012a745a5e5da0bf3fdbbeb99a3fad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.8/tofu_1.13.8_linux_arm64.zip"
      sha256 "efb05ff0e2403c8c29a6c7a02d5d95bf86f987063d1bbd5ae3e47621f752d139"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.8/tofu_1.13.8_linux_amd64.zip"
      sha256 "aa4382a5eefcf026309d07398ea803f97b9218a17d940999a938be22bfe9d73f"
    end
  end

  def install
    bin.install Dir["tofu*"].first => "tofu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tofu --version 2>&1", 1)
  end
end
