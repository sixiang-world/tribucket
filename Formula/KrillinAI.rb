class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "2.0.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.0.3/KrillinAI-cli_2.0.3_macOS_arm64"
      sha256 "71358abb6ee5e86de98836a51bb1abf943914c40a837780bae2d846284682ff6"
    end
    on_intel do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.0.3/KrillinAI-cli_2.0.3_macOS_amd64"
      sha256 "02d19578619642585faeada99b70275659a5147952842e44be6a77b70afedd7f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.0.3/KrillinAI-cli_2.0.3_Linux_arm64"
      sha256 "c2ff2c597064dc37681494d17f01e206b1615537a3ca049e76b285d2975461e2"
    end
    on_intel do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.0.3/KrillinAI-cli_2.0.3_Linux_x86_64"
      sha256 "555bcb909fd7cc35609cfb551aba07150d376b80c56ca39a335bb60e2bde35d1"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
