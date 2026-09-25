class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.14/mise-v2026.9.14-macos-arm64.tar.gz"
      sha256 "39bce868a71fac11dfd7c4170fcb6dcacfdd53dfab5656b23da56a85883568eb"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.14/mise-v2026.9.14-macos-x64.tar.gz"
      sha256 "3fd3e73e4ab239af542a88b8132023edaeeae8cefad61aed7ceedcc7ea45d54b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.14/mise-v2026.9.14-linux-arm64.tar.gz"
      sha256 "49a1185936100e061471d7035cbaf3eb13d17a6e1772daae2e1ec6cee0fb2d22"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.14/mise-v2026.9.14-linux-x64.tar.gz"
      sha256 "343b133839d6a1d6c92daca90c4dbf7981dc28de8d308e5198a4ef24df8f5338"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
