class Starship < Formula
  desc "Cross-shell prompt customization"
  homepage "https://github.com/starship/starship"
  version "1.25.1"
  license "ISC"

  on_macos do
    on_arm do
      url "https://github.com/starship/starship/releases/download/v1.25.1/starship-aarch64-apple-darwin.tar.gz"
      sha256 "1062a2363489b9335529b83204472f02633c08fc3609f1b325be5eba36feb631"
    end
    on_intel do
      url "https://github.com/starship/starship/releases/download/v1.25.1/starship-x86_64-apple-darwin.tar.gz"
      sha256 "f86fbe7a3b9f262bcf34ca61e9e996243da511c5500dcd81a1e4daa542869276"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/starship/starship/releases/download/v1.25.1/starship-aarch64-unknown-linux-musl.tar.gz"
      sha256 "01517aab398959ea9ea73bdb4f032ea4dbb51dff5c8e5eb05b4a1b9b7ab872b8"
    end
    on_intel do
      url "https://github.com/starship/starship/releases/download/v1.25.1/starship-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4488c11ca632327d1f1f16fb2f102c0646094c35479cd5435991385da43c61ac"
    end
  end

  def install
    bin.install Dir["starship*"].first => "starship"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/starship --version 2>&1", 1)
  end
end
