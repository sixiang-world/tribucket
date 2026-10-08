class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  version "2.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sharkdp/hyperfine/releases/download/v2.0.0/hyperfine-v2.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "590b839cfea386b384ce0b42d16daf2910277cf30950656194bb3a5f20dea81e"
    end
    on_intel do
      url "https://github.com/sharkdp/hyperfine/releases/download/v2.0.0/hyperfine-v2.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "8afe204926afefa406ad320cef0672b739e5f676c623fbd6d43d779bacd684e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sharkdp/hyperfine/releases/download/v2.0.0/hyperfine-v2.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f8244d1e17f8da23ee6b3ae2cdc04a6a185a450f6b74e09bff12e498038fcbc9"
    end
    on_intel do
      url "https://github.com/sharkdp/hyperfine/releases/download/v2.0.0/hyperfine-v2.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ae2beda2ac99c098427e4f755244552daf20e514422889cca6d44421e2d93c87"
    end
  end

  def install
    bin.install Dir["hyperfine*"].first => "hyperfine"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hyperfine --version 2>&1", 1)
  end
end
