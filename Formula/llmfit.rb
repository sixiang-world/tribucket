class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "0.9.33"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.33/llmfit-v0.9.33-aarch64-apple-darwin.tar.gz"
      sha256 "57bbd61a0a2c0ac5e75b27d0bf71f7122e227811cd8042ae573b48c0d30d20f1"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.33/llmfit-v0.9.33-x86_64-apple-darwin.tar.gz"
      sha256 "801354a1cc1728fd81f22845893dba5419e285f3d6af9acaf27f022090ae5a00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.33/llmfit-v0.9.33-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "210eb1e54bd82fce1646d6776985542d750611d809f07250bace047040275ad9"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.33/llmfit-v0.9.33-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bbe0665efa2435bca6e616c01174a8846ac2d5e7236db715d65458122ed0043a"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
