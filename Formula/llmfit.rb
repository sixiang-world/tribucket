class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "0.9.36"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.36/llmfit-v0.9.36-aarch64-apple-darwin.tar.gz"
      sha256 "9fb3d8ae8b7a1af59f71f253076491f42ecc295b47124ed00e7b385cc4e4e3d1"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.36/llmfit-v0.9.36-x86_64-apple-darwin.tar.gz"
      sha256 "257904ef16c88900b0948128da1aa177047dbb9f0ef4cbd6932616ae0a3ef24a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.36/llmfit-v0.9.36-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a05c1aafe63ef1585e3ff259803486fbeda923fbcb5b1668ece8b2a19fd84810"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.36/llmfit-v0.9.36-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f70f7d2302a3d45eb886450e6f859eafbda6e0d7809821020e6ccde9d1aa00e9"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
