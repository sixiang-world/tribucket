class Navidrome < Formula
  desc "Your Personal Streaming Service"
  homepage "https://github.com/navidrome/navidrome"
  version "0.64.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.0/navidrome_0.64.0_darwin_arm64.tar.gz"
      sha256 "ad35e6f00772c9325b5ce190cfcfaf985feeca406bea8f622dfa32b031b63019"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.0/navidrome_0.64.0_darwin_amd64.tar.gz"
      sha256 "967cab2522a9bed1c961403df8f442621294e145a81f3158c388a32388b00118"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.0/navidrome_0.64.0_linux_arm64.tar.gz"
      sha256 "74acac22979b5a3587f7ab0fd5616bf17deec0b0ad0a06fdc4c4f04deeb85c74"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.0/navidrome_0.64.0_linux_amd64.tar.gz"
      sha256 "efd94d11253234035b5d3cf284da917111736e72daeeda4f45a58251c60553ac"
    end
  end

  def install
    bin.install Dir["navidrome*"].first => "navidrome"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/navidrome --version 2>&1", 1)
  end
end
