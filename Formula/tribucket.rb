class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.7.1/tribucket-darwin-arm64"
      sha256 "afdb41db6966443eab0943a2f7533880866a21369976142775269cddd378e81e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.7.1/tribucket-linux-arm64"
      sha256 "829ab9c740d161cafb2b7d5071fd15a150b22b1beefa4ad3837cfa8982bbfadd"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.7.1/tribucket-linux-amd64"
      sha256 "6854c6ab66c76c021e5bde09cd7ba6e9c72dba1279d9805174c3a46f6a3b6c52"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
