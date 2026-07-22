class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.31"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.31/uv-aarch64-apple-darwin.tar.gz"
      sha256 "b2b93e82a6786f9c7cb89fd4ca0e859a147b292ae8f6f95784f9742f0efec39e"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.31/uv-x86_64-apple-darwin.tar.gz"
      sha256 "33ee6bd62b57fcd77a499deb54e4432dc1e1a2f3d34930ba987ad8b43f9c7bc7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.31/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d74f23949fd07be4970f293d06ca99d87cd2a78a341c3d7b7fc0df7bc2d8a145"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.31/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8cc1cd82d434ec565376f98bd938d4b715b5791a80ff2d3aa78821cf85091b4b"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
