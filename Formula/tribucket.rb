class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.0/tribucket-darwin-arm64"
      sha256 "75f8bb2bf64cf93fabeb7258296c58836bf239c7097b2ab073a9c74eab1066c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.0/tribucket-linux-arm64"
      sha256 "54cb31845967245501a341445b6a6bd789c4a4a9c49ec9bbd20c710a7d556161"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.0/tribucket-linux-amd64"
      sha256 "8665c71c653233f57ad873f7d502a854b1c1c4e0e5deb77d4797069f5f4b2221"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
