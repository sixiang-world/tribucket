class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.11.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.2/mise-v2026.11.2-macos-arm64.tar.gz"
      sha256 "658229370356b34be161a29ed9daf1342239b741a93e1a92d71ce040b7bb3e0c"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.2/mise-v2026.11.2-macos-x64.tar.gz"
      sha256 "ac3fe8f777556d5e57f14c9a525d2aa23ece3631cd350bd5b9ca0381c57aa564"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.2/mise-v2026.11.2-linux-arm64.tar.gz"
      sha256 "4d69f304a1501441cf455f6c7f96b117a10c27a568cdda3b5d1fa8e67476b038"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.2/mise-v2026.11.2-linux-x64.tar.gz"
      sha256 "c914dc3be1ad3588c3a7fa8ddae86c65e77eaf1777aa4a900c215e467f4c94a4"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
