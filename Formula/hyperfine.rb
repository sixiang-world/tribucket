class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  version "1.20.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sharkdp/hyperfine/releases/download/v1.20.0/hyperfine-v1.20.0-aarch64-apple-darwin.tar.gz"
      sha256 "8ee7067016620447c9d2d6234ec9a4680f958b7ad983549b56334668f63075b5"
    end
    on_intel do
      url "https://github.com/sharkdp/hyperfine/releases/download/v1.20.0/hyperfine-v1.20.0-x86_64-apple-darwin.tar.gz"
      sha256 "f58d0b90993fadfa122a351428c469ce24afef3865f027f0e6e86f0830d088f1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sharkdp/hyperfine/releases/download/v1.20.0/hyperfine-v1.20.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "90875cb1db7a1d797c311174d061728361e58fc70e3b62262a00635ac3b1997c"
    end
    on_intel do
      url "https://github.com/sharkdp/hyperfine/releases/download/v1.20.0/hyperfine-v1.20.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "63ad53934062118f5b0be11785e0bb1603d4b91667d1921f2fd8df9a8712040a"
    end
  end

  def install
    bin.install Dir["hyperfine*"].first => "hyperfine"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hyperfine --version 2>&1", 1)
  end
end
