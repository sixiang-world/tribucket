class Shfmt < Formula
  desc "Shell parser, formatter, and interpreter"
  homepage "https://github.com/mvdan/sh"
  version "3.13.1"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/mvdan/sh/releases/download/v3.13.1/shfmt_v3.13.1_darwin_arm64"
      sha256 "9680526be4a66ea1ffe988ed08af58e1400fe1e4f4aef5bd88b20bb9b3da33f8"
    end
    on_intel do
      url "https://github.com/mvdan/sh/releases/download/v3.13.1/shfmt_v3.13.1_darwin_amd64"
      sha256 "6feedafc72915794163114f512348e2437d080d0047ef8b8fa2ec63b575f12af"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mvdan/sh/releases/download/v3.13.1/shfmt_v3.13.1_linux_arm64"
      sha256 "32d92acaa5cd8abb29fc49dac123dc412442d5713967819d8af2c29f1b3857c7"
    end
    on_intel do
      url "https://github.com/mvdan/sh/releases/download/v3.13.1/shfmt_v3.13.1_linux_amd64"
      sha256 "fb096c5d1ac6beabbdbaa2874d025badb03ee07929f0c9ff67563ce8c75398b1"
    end
  end

  def install
    bin.install Dir["shfmt*"].first => "shfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt --version 2>&1", 1)
  end
end
