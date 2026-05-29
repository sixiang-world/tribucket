class Bat < Formula
  desc "A cat(1) clone with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  version "0.26.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sharkdp/bat/releases/download/v0.26.1/bat-v0.26.1-aarch64-apple-darwin.tar.gz"
      sha256 "e30beff26779c9bf60bb541e1d79046250cb74378f2757f8eb250afddb19e114"
    end
    on_intel do
      url "https://github.com/sharkdp/bat/releases/download/v0.26.1/bat-v0.26.1-x86_64-apple-darwin.tar.gz"
      sha256 "830d63b0bba1fa040542ec569e3cf77f60d3356b9de75116a344b061e0894245"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sharkdp/bat/releases/download/v0.26.1/bat-v0.26.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "422eb73e11c854fddd99f5ca8461c2f1d6e6dce0a2a8c3d5daade5ffcb6564aa"
    end
    on_intel do
      url "https://github.com/sharkdp/bat/releases/download/v0.26.1/bat-v0.26.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "726f04c8f576a7fd18b7634f1bbf2f915c43494c1c0f013baa3287edb0d5a2a3"
    end
  end

  def install
    bin.install Dir["bat*"].first => "bat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bat --version 2>&1", 1)
  end
end
