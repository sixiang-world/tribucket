class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.4/mise-v2026.10.4-macos-arm64.tar.gz"
      sha256 "744ae45f9b7c2a443adfa61df48397930e88b13c541834b7bd22ca31d4dfcfcd"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.4/mise-v2026.10.4-macos-x64.tar.gz"
      sha256 "3bf65cfdb543f69685afde3ae9ccd0b819b8f5ea5d12c67c73487bf2a1b16bf4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.4/mise-v2026.10.4-linux-arm64.tar.gz"
      sha256 "8760841cdbf964ecf9902a50c94716c77185a99af7f8eb55c9c51ec73ecd8880"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.4/mise-v2026.10.4-linux-x64.tar.gz"
      sha256 "2fc793020b442d08163603400236b2c693f8cede810c7e432fc77220e6c9e8a1"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
