class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.16"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.16/uv-aarch64-apple-darwin.tar.gz"
      sha256 "b6e03fae61704b1aa622f12b792a69483e837b83068e44f4fd34f8a07a8f74a3"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.16/uv-x86_64-apple-darwin.tar.gz"
      sha256 "a42bcc9ce97eb8b364d7f162233a9c6b8c0ee25388e551d362809795127e0c31"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.16/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "36d913ee9c647481d64f1a0a0485f85ff2feaee605c341fc22e73398f9212c26"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.16/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e5c6e5523dffc2dcf615bd995554c84c9feb4e577808a3fb8698a639d3f8d9c"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
