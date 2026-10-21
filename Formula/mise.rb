class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.17/mise-v2026.10.17-macos-arm64.tar.gz"
      sha256 "d7c50c1683524a764260986ccc9c41c0de5e1fcd491714b5640b657b76781af6"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.17/mise-v2026.10.17-macos-x64.tar.gz"
      sha256 "e42418100e2f781f9be00b9feaa60378e77551741faececc2bf360992c5410c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.17/mise-v2026.10.17-linux-arm64.tar.gz"
      sha256 "cac510e51793ad45e65fe92305bdbe4309c9c60b5907badbc7eba111738ab08f"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.17/mise-v2026.10.17-linux-x64.tar.gz"
      sha256 "17565e268c5542d8ce944321e17af81e0b741b65af4aa7e8e010ee77376a4aa3"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
