class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.4/mise-v2026.8.4-macos-arm64.tar.gz"
      sha256 "5d79a4e5df212017931e1b352715985a8680e7fe409e071aef723261db3a5b89"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.4/mise-v2026.8.4-macos-x64.tar.gz"
      sha256 "b47651e64724fe534b942ed81a0feb545fa6411c92c5eedf88de835963039aa4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.4/mise-v2026.8.4-linux-arm64.tar.gz"
      sha256 "1e51effb42a8f1fdbf1c39b1c7a452c809cbd791df7b7f59351c0920ed8e7ef6"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.4/mise-v2026.8.4-linux-x64.tar.gz"
      sha256 "b6760c6c4d5e629c31e31cb8a5018316338b01592408062a2aed673cec63cb2d"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
