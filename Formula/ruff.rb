class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.16.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.10/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "f051cd306de2691262a0574f8857cd1f4d6bfcd448084ea23d61b9c1c37df510"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.10/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "ace641df42926e962cf04bc52c79eb6c50ba1ae6a17b602f081960616ecc1bd1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.10/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dc0d74de837ef0a7bcc62ce98c48a622b075d057161f13b958be2934becd55a6"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.10/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9567ff1201e2fb3da31ff04c35587d768c66d6cb42dfa84de474e2bfe360b608"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
