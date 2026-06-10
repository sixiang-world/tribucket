class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.20"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.20/uv-aarch64-apple-darwin.tar.gz"
      sha256 "0a2b6a757d5693671a7ce0002554ae869604e1e69acb10313ac14d08374be01a"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.20/uv-x86_64-apple-darwin.tar.gz"
      sha256 "bef01a86faab997f6022b45cfa29bfc5b090f2f72cd4a91d2ecefe641efdabe7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.20/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c8b5b7f9c804b640da0bb66cddddf0a00ce971f64d8076622d70bd141bc80857"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.20/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5de211d9278af365497d387e25316907b3b4a9f25b4476dd6dbf238d6f85cff3"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
