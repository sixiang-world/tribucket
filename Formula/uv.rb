class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.17"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.17/uv-aarch64-apple-darwin.tar.gz"
      sha256 "2a162f6b90ff3691a2f9cae1622e066a3ce592e110f66670cdcc841324b28226"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.17/uv-x86_64-apple-darwin.tar.gz"
      sha256 "6c66e41eaf4d15abeda58d3f268161b6e3f742d98390341b174a7cfc1b48841d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.17/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "de008880a903ac2c5654647dc19a75c0d6652313c977a2bc5ce05e1e3a93429e"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.17/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0017ccecaeb4d431d7f93b583ebff0c5c38e00eb734fcf13d05f72ca419125fe"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
