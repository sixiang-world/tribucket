class Procs < Formula
  desc "Modern replacement for ps (process viewer)"
  homepage "https://github.com/dalance/procs"
  version "0.14.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dalance/procs/releases/download/v0.14.11/procs-v0.14.11-aarch64-mac.zip"
      sha256 "6650e7f354c07d0319d0f771ef8bb898ce8d0c841865a96c23281eebb033cac3"
    end
    on_intel do
      url "https://github.com/dalance/procs/releases/download/v0.14.11/procs-v0.14.11-x86_64-mac.zip"
      sha256 "72e45a61660e1c586afff64b3a8a393fed06f3a133df8e716ade68b00190ea87"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dalance/procs/releases/download/v0.14.11/procs-v0.14.11-aarch64-linux.zip"
      sha256 "891855dff3143fd3620c06eb68bd63e94114dd2e369107b455d48bf60cc1464c"
    end
    on_intel do
      url "https://github.com/dalance/procs/releases/download/v0.14.11/procs-v0.14.11-x86_64-linux.zip"
      sha256 "9c4faecf85a3af4d3d39aae47d04fa31d0a6eb0a239039f68d3f55043f04f974"
    end
  end

  def install
    bin.install Dir["procs*"].first => "procs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/procs --version 2>&1", 1)
  end
end
