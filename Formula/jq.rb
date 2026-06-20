class Jq < Formula
  desc "Lightweight command-line JSON processor"
  homepage "https://github.com/jqlang/jq"
  version "jq-1.8.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-macos-arm64"
      sha256 "2d75340ba57a4b4b4c8708a21c2dc8e958a48aaa8bba13b27f77f6e4c0eca07e"
    end
    on_intel do
      url "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-macos-amd64"
      sha256 "e94b266e3c26690550006abe63152b782280f4e14374accdf04cbde844f00bc0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-linux-arm64"
      sha256 "8b85c817833814ddca00a144c33705546355afccf0cf39b188f3cdb48b852309"
    end
    on_intel do
      url "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-linux64"
      sha256 "b1c22172dd303f3be49e935aa56aa48a8b7a46e0bc838b4997d3bb451495870f"
    end
  end

  def install
    bin.install Dir["jq*"].first => "jq"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jq --version 2>&1", 1)
  end
end
