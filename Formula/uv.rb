class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.26"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.26/uv-aarch64-apple-darwin.tar.gz"
      sha256 "8f7fbf1708399b921857bce71e1d60f0d3ccf52a30caebc1c1a2f175dce13ab6"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.26/uv-x86_64-apple-darwin.tar.gz"
      sha256 "922b460202707dd5f4ccacbadbe7f6a546cc46e82a99bf50ca99a7977a78eddd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.26/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "befa1a59c91e96eb601b0fd9a97c03dd666f17baba644b2b4db9c59a767e387e"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.26/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6426a73c3837e6e2483ee344cbc00f36394d179afcba6183cb77437e67db4af0"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
