class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.2/KrillinAI-CLI-3.2.2-mac-arm64.tar.gz"
      sha256 "774e934299c265d738156c86be8ce8425c559b5ed6098b3e4fa985a7ca88236b"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.2/KrillinAI-CLI-3.2.2-mac-x64.tar.gz"
      sha256 "b1eaac0131e213423c10e4448463ad2754a1c9f3ea0df6887c4772352fcccef4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.2/KrillinAI-CLI-3.2.2-linux-arm64.tar.gz"
      sha256 "234a21b47019690e78717efade30d5935d7fe1150bfe875a3964ca06dffb96fc"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.2/KrillinAI-CLI-3.2.2-linux-x64.tar.gz"
      sha256 "4a71c4a058dba7b4e4184551bdf76652584e8f0c9a1854122ff00d6a34864da8"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
