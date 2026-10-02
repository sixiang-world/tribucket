class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.22"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.22/uv-aarch64-apple-darwin.tar.gz"
      sha256 "5d714de09501a59393ceca78f4bc232a50478729640d251907160299b2a93ddd"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.22/uv-x86_64-apple-darwin.tar.gz"
      sha256 "1b8a5b316883df2daf20fb9a446e5b230e01d947d57aba2694977c5ac5a7e98c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.22/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6f66a14e8239871fb477f9746c941fedfa77e8fe28a8bc7c07e1dc7f53a66712"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.22/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b9980552309f09c15172b8be828555e375097f16deb459795ce7bfd200380f0b"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
