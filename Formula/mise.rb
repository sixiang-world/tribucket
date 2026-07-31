class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.18"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.18/mise-v2026.7.18-macos-arm64.tar.gz"
      sha256 "06472a4cf89fb5b698bb24b55e1405e1e241e609e051cdf6da72ac7953b374ef"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.18/mise-v2026.7.18-macos-x64.tar.gz"
      sha256 "dcfbaf69c3ade7767ab5a6ac7a8d84c7a3ed5cce6758a73baa8dec0b4b5566b5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.18/mise-v2026.7.18-linux-arm64.tar.gz"
      sha256 "0db0305237fd087862ae82175d619d288d321bae216ae1101cc733157a80b693"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.18/mise-v2026.7.18-linux-x64.tar.gz"
      sha256 "2cae8dc54812fa60bf652e6ebdc69cfee110660cddb27053f5442fded19dbc7d"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
