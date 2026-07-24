class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.13/mise-v2026.7.13-macos-arm64.tar.gz"
      sha256 "80dad4a76db564540be56ebd19e76165e2425e0b45f6f7aca6ac2d5efa3a6161"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.13/mise-v2026.7.13-macos-x64.tar.gz"
      sha256 "62563fe6e4799c6e499db4a328632f63499ee864581c923a7bb45bd90e8827bd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.13/mise-v2026.7.13-linux-arm64.tar.gz"
      sha256 "c002f9c3fd8ef7535afb5e20006cbdcc5f7e8144f7210057c241ec7e902743bc"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.13/mise-v2026.7.13-linux-x64.tar.gz"
      sha256 "2dfb74b2e09d1f73a4cfa0c4db0332418e39d35940b48f501b3b4004b59a379c"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
