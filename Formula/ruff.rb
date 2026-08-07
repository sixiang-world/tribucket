class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.16.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.2/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "fbf6cbc23d254b0bc03a6fb2b1b04efb917fe5ce068d027e735ce7ed65b9bed6"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.2/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "6648fa7a7c95b087c5b9d269d8b9a567fae091bdef3993f77cc7531a01bd7266"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.2/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b2a2a2573455cc33af98f8a8fb49294c02d4e2e4a7f9e81844411f0a57f30318"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.2/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3d2c355e641ceb5b608a158c603768fcc908c5009c56c6e78da7487da033b92a"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
