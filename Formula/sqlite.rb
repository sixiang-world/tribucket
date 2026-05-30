class Sqlite < Formula
  desc "Self-contained, serverless, zero-configuration SQL database engine"
  homepage "https://www.sqlite.org/"
  version "3.53.1"
  license "Public-Domain"

  on_macos do
    on_arm do
      url "https://sqlite.org/2026/sqlite-tools-osx-arm64-3530100.zip"
      sha256 "bae6c61af52de3dd828f47011265f1578e770d3d4d1a05f320195edee53574c2"
    end
    on_intel do
      url "https://sqlite.org/2026/sqlite-tools-osx-x64-3530100.zip"
      sha256 "71bab2ac76e7685168623bcb470231b9423b23baeac067a2acbdd58a88a9d673"
    end
  end

  on_linux do
    on_intel do
      url "https://sqlite.org/2026/sqlite-tools-linux-x64-3530100.zip"
      sha256 "fcd5e9da0f8852087025e3cc8175c2fc64a1ae7ec600fa422b8c4dda2e692a1d"
    end
  end

  def install
    bin.install Dir["sqlite3*"].first => "sqlite3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqlite3 --version 2>&1", 1)
  end
end
