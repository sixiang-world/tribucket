class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.5/mise-v2026.9.5-macos-arm64.tar.gz"
      sha256 "cb994f2e8a94fbf00300045c81ee799ffebcd8e78241ff37b0aa2da96b924aad"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.5/mise-v2026.9.5-macos-x64.tar.gz"
      sha256 "c31958952868b7b37ec6a5f46ee1a82d1382470bf15f2c663e7cb35ac0acf88c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.5/mise-v2026.9.5-linux-arm64.tar.gz"
      sha256 "3a52c7c7c58d21a0791516950ebf4bc915f403277b49c93d657fc585259625ec"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.5/mise-v2026.9.5-linux-x64.tar.gz"
      sha256 "d71e94e1ed59d4d0ca4ac847fa321d6d6615a8e613e9b468c9fb39f0dddd06d5"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
