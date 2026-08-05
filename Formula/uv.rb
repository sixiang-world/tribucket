class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.2/uv-aarch64-apple-darwin.tar.gz"
      sha256 "fa909fea3bc06f460db79017030a221fdbc43ec4478f089cb554d8335c090817"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.2/uv-x86_64-apple-darwin.tar.gz"
      sha256 "a6e6506a9109801222d65d17461abf4ed13bdecc5d2b13af0495418a82972c6b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.2/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "19b7f1f66895261fbaa07f8ea91da0f86337ad4e47efa594e87641c1718ffc52"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.2/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d66e96b5f1ca3b99806eee283a8125d33a0bd669e6e6d9bc4ab7ffda63c41bf4"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
