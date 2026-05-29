class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://github.com/helix-editor/helix"
  version "25.07.1"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/helix-editor/helix/releases/download/25.07.1/helix-25.07.1-aarch64-macos.tar.xz"
      sha256 "00b1651b4fdbbe0a2ae981c8e76b858bd26a7c33f5b3583f3b6bb9137d54f1ff"
    end
    on_intel do
      url "https://github.com/helix-editor/helix/releases/download/25.07.1/helix-25.07.1-x86_64-macos.tar.xz"
      sha256 "84dc32d617d28d32f4aa21e3aafac47bd715d1154aeb977697d4d60b887b7103"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/helix-editor/helix/releases/download/25.07.1/helix-25.07.1-aarch64-linux.tar.xz"
      sha256 "ce23fa8d395e633e3e54c052012f11965d91d8d5c2bfa659685f50430b4f8175"
    end
    on_intel do
      url "https://github.com/helix-editor/helix/releases/download/25.07.1/helix-25.07.1-x86_64-linux.tar.xz"
      sha256 "3f08e63ecd388fff657ad39722f88bb03dcf326f1f2da2700d99e1dc40ab2e8b"
    end
  end

  def install
    bin.install Dir["hx*"].first => "hx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hx --version 2>&1", 1)
  end
end
