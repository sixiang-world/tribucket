class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.13/mise-v2026.10.13-macos-arm64.tar.gz"
      sha256 "b91f1b30bd9e7e6899899f0ff5ac5625a90c86daa652524f7b8922db3287ff60"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.13/mise-v2026.10.13-macos-x64.tar.gz"
      sha256 "53dd8c3f08a995e88a300e561183bdd294f2aedd7d986dbcaa6c9a649dab6528"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.13/mise-v2026.10.13-linux-arm64.tar.gz"
      sha256 "ec1630fd441434a1b8c8c0074a53e3e8cc955ad313e9f354c44775eb19103a57"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.13/mise-v2026.10.13-linux-x64.tar.gz"
      sha256 "b775d3feee8f0cdb1934c60a1ec26526d6eb7cdeb258b48c64cfadcec07a8fec"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
