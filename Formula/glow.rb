class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  version "2.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/charmbracelet/glow/releases/download/v2.1.2/glow_2.1.2_Darwin_arm64.tar.gz"
      sha256 "6f7abfb47de69fbf7b0e67d2fa019cc554916e8b6694f9877212be89fc7ebb8c"
    end
    on_intel do
      url "https://github.com/charmbracelet/glow/releases/download/v2.1.2/glow_2.1.2_Darwin_x86_64.tar.gz"
      sha256 "8cbc78a4947c68e804edf34d36070153fcc5d424873152da83ad6be14fa88ed3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/charmbracelet/glow/releases/download/v2.1.2/glow_2.1.2_Linux_arm64.tar.gz"
      sha256 "cf63abebcb50b72909db965d78290e7cecbf17a900e84705dc84addbb6952099"
    end
    on_intel do
      url "https://github.com/charmbracelet/glow/releases/download/v2.1.2/glow_2.1.2_Linux_x86_64.tar.gz"
      sha256 "6063d4f2af8a82a5f4bba0831e165de9381660aa8b41df4816d0106a265b07d5"
    end
  end

  def install
    bin.install Dir["glow*"].first => "glow"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glow --version 2>&1", 1)
  end
end
