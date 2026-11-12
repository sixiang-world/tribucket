class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.11.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.7/mise-v2026.11.7-macos-arm64.tar.gz"
      sha256 "92f1b9f68b6031a9f77938a0ff8dfd7a77fe9cd918c5b09d0ed434f06ebbd3f2"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.7/mise-v2026.11.7-macos-x64.tar.gz"
      sha256 "69a0eddf86f275cb81be9d49a607460f2c068d77c1c0e37b2d81513074eff36c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.7/mise-v2026.11.7-linux-arm64.tar.gz"
      sha256 "b8de6c8e7aa85752a6a2368df32393552a2d8947b6f4072ecd29a1ad972e5c40"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.7/mise-v2026.11.7-linux-x64.tar.gz"
      sha256 "3198a5ed5716ca8c17ecfc54521e2769d6cacbf2d13f24f0c2f9706620ec0024"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
