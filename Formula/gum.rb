class Gum < Formula
  desc "A tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  version "2.0.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/charmbracelet/gum/releases/download/v2.0.2/gum_2.0.2_Darwin_arm64.tar.gz"
      sha256 "4777a69b1170b8db23c95d5889fb32186cfda1a3ac950d339aa17e3513633890"
    end
    on_intel do
      url "https://github.com/charmbracelet/gum/releases/download/v2.0.2/gum_2.0.2_Darwin_x86_64.tar.gz"
      sha256 "5374966c7c7199ea879fcaa525ddc6d447a098d3d35496e430a9a1ef38d30485"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/charmbracelet/gum/releases/download/v2.0.2/gum_2.0.2_Linux_arm64.tar.gz"
      sha256 "8ebf8b54ec1e8c81f2bb58b59ff9b70998186a4d11375f0cf357b80e0ccfa1d5"
    end
    on_intel do
      url "https://github.com/charmbracelet/gum/releases/download/v2.0.2/gum_2.0.2_Linux_x86_64.tar.gz"
      sha256 "d842e06d93dbed90af48cb8dd10698db6f22e331fc40346bb37bbc753109edc2"
    end
  end

  def install
    bin.install Dir["gum*"].first => "gum"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gum --version 2>&1", 1)
  end
end
