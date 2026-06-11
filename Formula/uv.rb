class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.21"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.21/uv-aarch64-apple-darwin.tar.gz"
      sha256 "1f921d491ba5ffeea774eb04d6681ecee379101341cbb1500394993b541bf3f4"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.21/uv-x86_64-apple-darwin.tar.gz"
      sha256 "f3c8e5708a84b920c18b691214d54d2b0da6b984789caae95d47c95120cb7765"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.21/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "88e800834007cc5efd4675f166eb2a51e7e3ad19876d85fa8805a6fb5c922397"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.21/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8c88519b0ef0af9801fcdee419bbb12116bd9e6b18e162ae093c932d8b264050"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
