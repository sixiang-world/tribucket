class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.8.24"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.24/ccx-darwin-arm64"
      sha256 "819b68160550704cc473f7a93adc2870b373fd3b801da7a7fe6359f1781405b3"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.24/ccx-darwin-amd64"
      sha256 "1ab395d59b897467f7786dc10e3b7b0f0a2ae3f855852852bbc1f4c32bd03adc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.24/ccx-linux-arm64"
      sha256 "17238d3b5b40af859c60c160bf6b66427098fa5afac6877517404132dcdee663"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.24/ccx-linux-amd64"
      sha256 "4de416d01299fef458183a2ab6135dba286bf636120fe99abec0e7dcb7e9e855"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
