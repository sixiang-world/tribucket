class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.10/mise-v2026.10.10-macos-arm64.tar.gz"
      sha256 "6f99b395c8d2a4364fd5cf6a73521fb7f8444831a330db6a4c7cea9a58d69930"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.10/mise-v2026.10.10-macos-x64.tar.gz"
      sha256 "63f308ac41c86ab9b3fbaecf26e8825264e9731960d6c665778d64e0e9b47151"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.10/mise-v2026.10.10-linux-arm64.tar.gz"
      sha256 "b67f4ad5e35199b14362aa64d065977f8513a2046430179c2ab42262914a73b0"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.10/mise-v2026.10.10-linux-x64.tar.gz"
      sha256 "58063fdda315c29ff7504daf8f2414462d6a52e4de2243c3ce23f849975a4ab5"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
