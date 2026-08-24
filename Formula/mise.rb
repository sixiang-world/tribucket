class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.12/mise-v2026.8.12-macos-arm64.tar.gz"
      sha256 "399c35fa79008e41dda22bbe7796f72e33f99174bc80bc4ff1881c2999bfca47"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.12/mise-v2026.8.12-macos-x64.tar.gz"
      sha256 "2ffdef62109448c4de3c95e9158e176ad2a37177152bc6e32c844b98e92d1b93"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.12/mise-v2026.8.12-linux-arm64.tar.gz"
      sha256 "3ec7d4fd8ebd923794612a3cc89cb44617943845ebf0f4cea9a325dbb3756184"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.12/mise-v2026.8.12-linux-x64.tar.gz"
      sha256 "0c782233b97745fd3ed317ba3acbfd7d256e6268470373757f0cc48d57bb87e6"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
