class Chsrc < Formula
  desc "Full-platform universal source changing tool and framework"
  homepage "https://github.com/RubyMetric/chsrc"
  version "0.2.5"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.5/chsrc-aarch64-macos"
      sha256 "b46f2fb54af6e44b13889ba809ac09e7a242d6039438d89ad3957a62878f195f"
    end
    on_intel do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.5/chsrc-x64-macos"
      sha256 "d4d4b0c0c30cb928edad2e6464d294bc78502e2b73b58023ed0d27902449cc5f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.5/chsrc-aarch64-linux"
      sha256 "d65a46f970cbe3f1f584076a8979309dee6509ae44c04146a7a76b55fed70436"
    end
    on_intel do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.5/chsrc-x64-linux"
      sha256 "60d170f779adec36e31d33ebc931db92fa246b7730fbabeb5b6373530febf2cd"
    end
  end

  def install
    bin.install Dir["chsrc*"].first => "chsrc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chsrc --version 2>&1", 1)
  end
end
