class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.2.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.7/KrillinAI-CLI-3.2.7-mac-arm64.tar.gz"
      sha256 "a6ee66794b3f0c95b1f926c87f45dacbc6f9f4dff1de5b3af01e7be6189b1656"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.7/KrillinAI-CLI-3.2.7-mac-x64.tar.gz"
      sha256 "9e41d88a6f06c96b103761f669d1b8f52334f349c59d2d16801fc9157476c423"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.7/KrillinAI-CLI-3.2.7-linux-arm64.tar.gz"
      sha256 "1ef681d52d17e75eafa9e35f50d3ae3190188b0bfc366798ef304a64f56dbf13"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.7/KrillinAI-CLI-3.2.7-linux-x64.tar.gz"
      sha256 "5d799cf0cda3047f8185df3b9227919f801da919f2bafe267c100f4fa008fe72"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
