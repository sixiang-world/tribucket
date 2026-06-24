class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.24"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.24/uv-aarch64-apple-darwin.tar.gz"
      sha256 "7578c6087c5cd76981732b1f5d126248101faebdf81016ba780a65ce03653cdf"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.24/uv-x86_64-apple-darwin.tar.gz"
      sha256 "8e026ec796a2760c33c832298b0910bf07fb369d00cc075761c321923ac37522"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.24/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e22c66d36a0098b17cff80a8647e0b8c58202af899d4e9eb820fc7ad126435a1"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.24/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5ce1ad074a78f96c5c8122088bb85a12eb282195bc1453151a48762e4fc31fed"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
