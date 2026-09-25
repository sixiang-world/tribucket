class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.19"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.19/uv-aarch64-apple-darwin.tar.gz"
      sha256 "a9a8df1eedeb192f2e47e40e2faabfb387db4b850209118786d42f89dde3e0ba"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.19/uv-x86_64-apple-darwin.tar.gz"
      sha256 "cb5fa57bafe68fc0fb94b17f06bee0b0b9a7feb94ccbd110445afa0696e39273"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.19/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0804e9b164c64b6914182d5920c08551958a095986f10a3731056df701126436"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.19/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23bf5552d220e0842b65c862097b2ebaeba0064b74eda5e565e77fd25969d8c8"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
