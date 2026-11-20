class DragonwellJdk21 < Formula
  desc "Alibaba Dragonwell - downstream distribution of OpenJDK"
  homepage "https://www.aliyun.com/product/dragonwell"
  version "21.0.13.0.13+9"
  license "GPL-2.0"

  on_linux do
    on_arm do
      url "https://github.com/dragonwell-project/dragonwell21/releases/download/dragonwell-extended-21.0.13.0.13%2B9_jdk-21.0.13-ga/Alibaba_Dragonwell_Extended_21.0.13.0.13.9_aarch64_linux.tar.gz"
      sha256 "2b2e5df7449a0c7c8764e2fbf169420a588224723b3ed839424e6f7743dfcdbe"
    end
    on_intel do
      url "https://github.com/dragonwell-project/dragonwell21/releases/download/dragonwell-extended-21.0.13.0.13%2B9_jdk-21.0.13-ga/Alibaba_Dragonwell_Extended_21.0.13.0.13.9_x64_linux.tar.gz"
      sha256 "9b1a05a13e343afea4c42c01110e058fbf8aea9cf317d712f31931acf36b4938"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
