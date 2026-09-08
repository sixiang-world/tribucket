class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.11"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.11/uv-aarch64-apple-darwin.tar.gz"
      sha256 "e01b69ee15e81918d5e8fc9cf39b3db7f59c5576e5e306cd9b7aeb2c7b7321c3"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.11/uv-x86_64-apple-darwin.tar.gz"
      sha256 "96d773bf5fda4f9b08c4444847f9183d1c14bc8a28ff9c0490e261a8fc6e5309"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.11/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e9933d907fb9cd27d606d819bbded419f2844c0e2efc98225ecfa409288eb28d"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.11/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4ae93e0f148a18434cc094072547cec88912fc4a72b984183c7d0d0e9586cb5e"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
