class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.19"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.19/uv-aarch64-apple-darwin.tar.gz"
      sha256 "d8f59c38e8c4168ee468d423cd63184be12fa6995a4283d41ee1a14d003c9453"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.19/uv-x86_64-apple-darwin.tar.gz"
      sha256 "1585f415cade9f061e7f00fe5b00030a79ccfac60c650242ce639ba946138d40"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.19/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "83b13ab184a45b7d9a3b0e4b10eaebd50ad41e66cb16dcce8e60aa7be13ae399"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.19/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7035608168e106375b36d0c818d537a889c51a8625fe7f8f7cad5e62b947c368"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
