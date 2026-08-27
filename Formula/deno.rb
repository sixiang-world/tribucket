class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.9.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.6/deno-aarch64-apple-darwin.zip"
      sha256 "213a2f304f04d3c9cb5220669afad138f60a5aab1fe80962abdeb8f35807a472"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.6/deno-x86_64-apple-darwin.zip"
      sha256 "7d4524b82bcc557fe020a1a5b56956ed42b992ae5b28026e8ad5d17329533f5f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.6/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "9a46afc6c392c7cd2ff71a31558935545b46408d0e87f7a86908c712721c046e"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.6/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "394f07f4da2bebe6ce6f1e7ce0fa16429b29b08c35e3fac3fe25972676dff4b2"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
