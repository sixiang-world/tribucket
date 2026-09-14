class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.8/mise-v2026.9.8-macos-arm64.tar.gz"
      sha256 "a06f7e0d425848a09278af3da48b463491db2aa70e4a236e06476b25c5eb95bc"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.8/mise-v2026.9.8-macos-x64.tar.gz"
      sha256 "edaa8219a64486be6e8d66e6815a6908602f47588741ab42bc7bffe27d204987"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.8/mise-v2026.9.8-linux-arm64.tar.gz"
      sha256 "bf6b498d1ee5cdcd7b50923f06c2bbf19f85746c662eb1e6b1677888f256956c"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.8/mise-v2026.9.8-linux-x64.tar.gz"
      sha256 "9809cd06cd86bcc88b262038605019645a069019ee1c1a49cbc7ea7386cc08dd"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
