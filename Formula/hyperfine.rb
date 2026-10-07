class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  version "1.21.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sharkdp/hyperfine/releases/download/v1.21.0/hyperfine-v1.21.0-aarch64-apple-darwin.tar.gz"
      sha256 "4a6e8d9fad128557b31c471d81c60dd1576729c5ab2841998c457a3467ce4469"
    end
    on_intel do
      url "https://github.com/sharkdp/hyperfine/releases/download/v1.21.0/hyperfine-v1.21.0-x86_64-apple-darwin.tar.gz"
      sha256 "60ad42427f09647ea2f301186282c083d75a2f1c5d82e7b9d89f7524f1b9fd57"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sharkdp/hyperfine/releases/download/v1.21.0/hyperfine-v1.21.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7c3e7183e4178e5c1bb68ef714fbf2ac1cef04d4d7fc751d645d290ac0041d7a"
    end
    on_intel do
      url "https://github.com/sharkdp/hyperfine/releases/download/v1.21.0/hyperfine-v1.21.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "60b70eb01e1a4dce1bf56a38393e1e2c2e79ed95a4ba711feb5c993f382604ab"
    end
  end

  def install
    bin.install Dir["hyperfine*"].first => "hyperfine"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hyperfine --version 2>&1", 1)
  end
end
