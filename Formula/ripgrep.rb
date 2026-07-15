class Ripgrep < Formula
  desc "Recursively search directories for a regex pattern (rg)"
  homepage "https://github.com/BurntSushi/ripgrep"
  version "15.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BurntSushi/ripgrep/releases/download/15.2.0/ripgrep-15.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "3750b2e93f37e0c692657da574d7019a101c0084da05a790c83fd335bad973e4"
    end
    on_intel do
      url "https://github.com/BurntSushi/ripgrep/releases/download/15.2.0/ripgrep-15.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "af7825fcc69a2afc7a7aea55fc9af90e26421d8f20fe59df32e233c0b8a231c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BurntSushi/ripgrep/releases/download/15.2.0/ripgrep-15.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a740b91c82eaf9914cfedd353572f2791cbe0162c84101ee0951058f4dcbc90d"
    end
    on_intel do
      url "https://github.com/BurntSushi/ripgrep/releases/download/15.2.0/ripgrep-15.2.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "33e15bcf1624b25cdd2a55813a47a2f95dbe126268203e76aa6a585d1e7b149c"
    end
  end

  def install
    bin.install Dir["rg*"].first => "rg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rg --version 2>&1", 1)
  end
end
