class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.27"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.27/uv-aarch64-apple-darwin.tar.gz"
      sha256 "34e63cc0de0aebbc8d424767c588c31b685479f045f9ced9e5ef43ff9e0e8d63"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.27/uv-x86_64-apple-darwin.tar.gz"
      sha256 "9f00047455b2a9e81f282297fca39cdd6cd5761a6b0ce75e2d7698744c59e1af"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.27/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "321580b9a7069d0cdbd8db9482a5fb62b4f1285110f847746e3b495408e3a08c"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.27/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0f4088a04ac92e4c52b4b76759d227a1047355e0ce1dd57cd738a6dec5966bd9"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
