class Ripgrep < Formula
  desc "Recursively search directories for a regex pattern (rg)"
  homepage "https://github.com/BurntSushi/ripgrep"
  version "15.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep-15.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "378e973289176ca0c6054054ee7f631a065874a352bf43f0fa60ef079b6ba715"
    end
    on_intel do
      url "https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep-15.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "64811cb24e77cac3057d6c40b63ac9becf9082eedd54ca411b475b755d334882"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep-15.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1c9297be4a084eea7ecaedf93eb03d058d6faae29bbc57ecdaf5063921491599"
    end
  end

  def install
    bin.install Dir["rg*"].first => "rg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rg --version 2>&1", 1)
  end
end
