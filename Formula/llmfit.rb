class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "0.9.29"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.29/llmfit-v0.9.29-aarch64-apple-darwin.tar.gz"
      sha256 "c11c3505fa037a1efe6adef080fdcbf77407aa788e4cf6451736101b82149e7c"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.29/llmfit-v0.9.29-x86_64-apple-darwin.tar.gz"
      sha256 "4cc199279c1eddb752688c3feae126ae71d7d1a51a57ef92a7f6d142541283a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.29/llmfit-v0.9.29-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "42c8a0b08c9a366c962cf94ed5931e12aa4bd81f3f8e8f3a95b7516f2d165ee2"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.29/llmfit-v0.9.29-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a7ea618f2e859514ebbd877779f126f653369b89526aca2a92959e8aa619ccf0"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
