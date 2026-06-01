class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.18"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.18/uv-aarch64-apple-darwin.tar.gz"
      sha256 "1a7adf8dadae3b55853115d13a8bf564d219597ad13824b93b213706933863e5"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.18/uv-x86_64-apple-darwin.tar.gz"
      sha256 "00a61e3db99b53c927a7e6c4ccdccb898aa3253d07928822211e9dc570a25661"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.18/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0f03c6648df1c159557f4222c0f37250f84733fb88d6fc3c16770e17c177a8c9"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.18/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "588f3e360f69ce02b6982aa99f2240e803933a6b7e176ac01617830adf955add"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
