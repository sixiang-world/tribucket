class Opentofu < Formula
  desc "Open-source infrastructure as code tool (Terraform fork)"
  homepage "https://github.com/opentofu/opentofu"
  version "1.12.3"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.3/tofu_1.12.3_darwin_arm64.zip"
      sha256 "2b81c065cdcf5e573cfb5d9e0c663ac4cfc32512927078b645b58ef81cec2474"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.3/tofu_1.12.3_darwin_amd64.zip"
      sha256 "0898350dcc5b2ae31ad104cf4882228d08f858ba28f4e8bea693b51d1b267c57"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.3/tofu_1.12.3_linux_arm64.zip"
      sha256 "b2110d1ce46e366ce861b7f53d293dad99080075629aed7fb50d7328916d91c2"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.12.3/tofu_1.12.3_linux_amd64.zip"
      sha256 "46b48c3438c65cf479fc076c9281422ffa2f493548d1e813d154c835c5986a08"
    end
  end

  def install
    bin.install Dir["tofu*"].first => "tofu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tofu --version 2>&1", 1)
  end
end
