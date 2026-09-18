class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.17"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.17/uv-aarch64-apple-darwin.tar.gz"
      sha256 "85f00cbdc6dd3e97eba4c31b4d014375a9fdfe8f570023b84e5102fc3456896b"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.17/uv-x86_64-apple-darwin.tar.gz"
      sha256 "8dcf05a8c809bb3c471d2b614788ba27a6e41298fc8c31ac84b5f4339fd468e5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.17/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d636d1b678e9e7f367ecb22b46bd1cabbed234d6bc3b4d96365d2b507f72f86c"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.17/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fa82fd8dde8e8eefdecada6aa0889666556cfceb690d06e0c3bca49eb3070a63"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
