class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.19"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.19/mise-v2026.10.19-macos-arm64.tar.gz"
      sha256 "a8a581e115f4ebdbe2931c237949dbac7624bd8b4024bf3eb9da7981bde490c9"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.19/mise-v2026.10.19-macos-x64.tar.gz"
      sha256 "6949650ed321f6c36455bd755e06487cd1cc232140c7025d602a62db41891f43"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.19/mise-v2026.10.19-linux-arm64.tar.gz"
      sha256 "f6dbd376928095d3bc8fde72eb1b27a8450d35c1795aa80c05aacf1ce42584aa"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.19/mise-v2026.10.19-linux-x64.tar.gz"
      sha256 "b7ad610a39474b36663a6b1134c17086fa77e0f39b7ecce85c684165eed5f086"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
