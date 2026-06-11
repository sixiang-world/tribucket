class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.8.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.8.3/deno-aarch64-apple-darwin.zip"
      sha256 "88b350be928fdba0e5d8142ff7c101a17133426371e3cf5ed0e0f74e62476f6c"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.8.3/deno-x86_64-apple-darwin.zip"
      sha256 "4254ec12123cfcf88b87703d7acf092a1ea024bdf9be8dd3cd9d4474761cb74e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.8.3/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "d4589cc1ffcbf1995c92a0127d932aaf832ac70cfdcc6d5b7bf38043cf303575"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.8.3/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "30455b845ffa6082209c3590269c910ad3b7efdf28c9879afd4006c47ae54197"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
