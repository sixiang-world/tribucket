class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.11/mise-v2026.9.11-macos-arm64.tar.gz"
      sha256 "34e8296f932c1d6f3b84d924bbb9f2841336d7bee1c373005d479e13664cb6c0"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.11/mise-v2026.9.11-macos-x64.tar.gz"
      sha256 "46a67b050d53f1ee795353f8ff5ecfd79328a1f6415f4b3ede79ecda7223f969"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.11/mise-v2026.9.11-linux-arm64.tar.gz"
      sha256 "d781ce1b4daad6ead469b0a57fef4bfb49c4e02025dc88111ff1bfaa8c90aad9"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.11/mise-v2026.9.11-linux-x64.tar.gz"
      sha256 "02a19e4a5eda23cda916503ad09dbc608a249fe7a7d5686c5a74ff3a7ce3b7e0"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
