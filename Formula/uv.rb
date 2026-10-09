class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.24"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.24/uv-aarch64-apple-darwin.tar.gz"
      sha256 "0c4346de7abdb49495b393b9ec809fe387aa43e586be20fecb972216c1e71732"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.24/uv-x86_64-apple-darwin.tar.gz"
      sha256 "4fa82e37cb94767661f532b001e470b67a186c7260e305bd84ddb78fd545c0b6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.24/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5231be65f496304623895dacdbf1de8504fec90303684bdf05805aa34414dd21"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.24/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b4dfaef47d491a7296981f8374a4595f55dbf84e8937c8ecd2983574d8bb3da6"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
