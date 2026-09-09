class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.12"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.12/uv-aarch64-apple-darwin.tar.gz"
      sha256 "46740540b63fdee9a6cb2e19baf3f1f475b850c440a33e63455087a6871263f1"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.12/uv-x86_64-apple-darwin.tar.gz"
      sha256 "0dc8cd6c961582b0d140b5398f96b23502885277fb3464241456a2435e460dfa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.12/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fe08db50cc1b56cd1da7801065ed1103d27ed3f9571cd122386cfc7faf1b8df5"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.12/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ab9b309d4586403f024e100abaceb396616e178a553e2500c36087d180f09509"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
