class Opentofu < Formula
  desc "Open-source infrastructure as code tool (Terraform fork)"
  homepage "https://github.com/opentofu/opentofu"
  version "1.13.2"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.2/tofu_1.13.2_darwin_arm64.zip"
      sha256 "cb46112c095f1c4da721b6a18c8368f67341896a62205d1c117299e85993af61"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.2/tofu_1.13.2_darwin_amd64.zip"
      sha256 "2093d0f881d911eb133cf51d2d7e09f22da71b1e6465c60826a314d217b0b84e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.2/tofu_1.13.2_linux_arm64.zip"
      sha256 "6e815c58a09ee957de606ff48cefad082942e70afc43b737ff975654c54ec453"
    end
    on_intel do
      url "https://github.com/opentofu/opentofu/releases/download/v1.13.2/tofu_1.13.2_linux_amd64.zip"
      sha256 "723bebb0df8411daff1e5fc3862e28ff5581fe5634087f4c29a9aa41d78208b5"
    end
  end

  def install
    bin.install Dir["tofu*"].first => "tofu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tofu --version 2>&1", 1)
  end
end
