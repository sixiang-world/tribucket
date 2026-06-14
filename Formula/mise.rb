class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.6.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.9/mise-v2026.6.9-macos-arm64.tar.gz"
      sha256 "ca44fd180602cb54a5d9ed3ba574a80c5e6835d41fd7c2a9aa50c13bc4905143"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.9/mise-v2026.6.9-macos-x64.tar.gz"
      sha256 "2fe95372dafac5fd06d69ea7dbec6f0f5b8a434b5c4f3fdec524d44e2a92f028"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.9/mise-v2026.6.9-linux-arm64.tar.gz"
      sha256 "692b8b2febbf6883d1884d2e92db6ef8601609689a64273faddb52ed24d4a9c3"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.9/mise-v2026.6.9-linux-x64.tar.gz"
      sha256 "aa6b08bebec1518a47f1b4382320f14006d9037d3bac0d8d8735dde24daa498d"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
