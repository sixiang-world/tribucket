class Jq < Formula
  desc "Lightweight command-line JSON processor"
  homepage "https://github.com/jqlang/jq"
  version "jq-1.8.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-macos-arm64"
      sha256 "a9fe3ea2f86dfc72f6728417521ec9067b343277152b114f4e98d8cb0e263603"
    end
    on_intel do
      url "https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-macos-amd64"
      sha256 "e80dbe0d2a2597e3c11c404f03337b981d74b4a8504b70586c354b7697a7c27f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-arm64"
      sha256 "6bc62f25981328edd3cfcfe6fe51b073f2d7e7710d7ef7fcdac28d4e384fc3d4"
    end
    on_intel do
      url "https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux64"
      sha256 "020468de7539ce70ef1bceaf7cde2e8c4f2ca6c3afb84642aabc5c97d9fc2a0d"
    end
  end

  def install
    bin.install Dir["jq*"].first => "jq"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jq --version 2>&1", 1)
  end
end
