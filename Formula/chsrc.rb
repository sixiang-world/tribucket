class Chsrc < Formula
  desc "Full-platform universal source changing tool and framework"
  homepage "https://github.com/RubyMetric/chsrc"
  version "0.2.7"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.7/chsrc-aarch64-macos"
      sha256 "951c5e4e9073d4f78e4610cce9b4bddb65094d966dc742d9d8931919ed743e8e"
    end
    on_intel do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.7/chsrc-x64-macos"
      sha256 "d512b13df67d11506b3bc9dfa99b9eae8c742864bf5b58bb6743f7593ab9758c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.7/chsrc-aarch64-linux"
      sha256 "64e176a6cdcfdaa7f25a604ed2be62587d81dfe1e048608302384da1c4063703"
    end
    on_intel do
      url "https://github.com/RubyMetric/chsrc/releases/download/v0.2.7/chsrc-x64-linux"
      sha256 "70d236dbd346e969a3d2abe507343eb07419be494ff40fd117cad44c619465d5"
    end
  end

  def install
    bin.install Dir["chsrc*"].first => "chsrc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chsrc --version 2>&1", 1)
  end
end
