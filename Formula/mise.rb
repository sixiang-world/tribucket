class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.11.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.9/mise-v2026.11.9-macos-arm64.tar.gz"
      sha256 "e4509f159e0492e89065edcf52f2918e2751e3574620586058468ba0563aed59"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.9/mise-v2026.11.9-macos-x64.tar.gz"
      sha256 "21288d7a2d82066f1a2ce83c48b7b4b57753edd739b6309e578aafce0edc8a03"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.9/mise-v2026.11.9-linux-arm64.tar.gz"
      sha256 "cf2900bfb4279f8d8f8a19d5c27bf1bde826b3e742182f3f67511c588498c786"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.9/mise-v2026.11.9-linux-x64.tar.gz"
      sha256 "23ba592fcbc61f057e2b82c1eafd085832712ba0c759b714ca16cd06babca378"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
