class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.4/mise-v2026.7.4-macos-arm64.tar.gz"
      sha256 "9e8817b7130d98cc2e8a00c2557673d1456d48319e2e31ae4bc7b06d50c4d7f2"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.4/mise-v2026.7.4-macos-x64.tar.gz"
      sha256 "405d7ce976b43d2de69e46097e18f48c6111ba0c9e12c8d668ba4dbc6d3ab523"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.4/mise-v2026.7.4-linux-arm64.tar.gz"
      sha256 "7a59e36862b64596ca9f8693859b41706a8989841e178f7b9da5ed75554da8cb"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.4/mise-v2026.7.4-linux-x64.tar.gz"
      sha256 "4de4203579ba9f83ae26561190f2f6b46f41860117e43c4cd6adf4d5100a961d"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
