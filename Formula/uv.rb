class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.5"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.5/uv-aarch64-apple-darwin.tar.gz"
      sha256 "5bb0e5fe008a773c3dbcb97ff79cd89e1241464fe9d2f986d52ad8f1b037bd62"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.5/uv-x86_64-apple-darwin.tar.gz"
      sha256 "b3b2137477cf96c9686ebfb71524614cec780c673fd73e59bce099aef02e70e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.5/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9bf43b4d1a07665bf64d4c4e710930b382321a785e0eb10aac07f46471f86a31"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.5/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "68a509da24b06b4223a1c0175fb5eb5bc79342b76cbeff0cfe51ac3f5b17b6b2"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
