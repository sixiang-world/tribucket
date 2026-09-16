class Procs < Formula
  desc "Modern replacement for ps (process viewer)"
  homepage "https://github.com/dalance/procs"
  version "0.14.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dalance/procs/releases/download/v0.14.12/procs-v0.14.12-aarch64-mac.zip"
      sha256 "20c7a33426ed7a43c3e13a48f2d1866ecc979a8ad46733f86ddc78ab7f12d49c"
    end
    on_intel do
      url "https://github.com/dalance/procs/releases/download/v0.14.12/procs-v0.14.12-x86_64-mac.zip"
      sha256 "2c276f40c99051984942a5b135b74ce4bc9184984a1543dddfcf275bde71d8d4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dalance/procs/releases/download/v0.14.12/procs-v0.14.12-aarch64-linux.zip"
      sha256 "74b4f82acc6fe553cbd5af20ba0baac420b42bef9bb0cbb38fef14b8317d9f91"
    end
    on_intel do
      url "https://github.com/dalance/procs/releases/download/v0.14.12/procs-v0.14.12-x86_64-linux.zip"
      sha256 "81964faf9d5cd0e9f399d5d0954fb6fe4d4d9f7d3cbec4507633df5a45b11713"
    end
  end

  def install
    bin.install Dir["procs*"].first => "procs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/procs --version 2>&1", 1)
  end
end
