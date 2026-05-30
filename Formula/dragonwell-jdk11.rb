class DragonwellJdk11 < Formula
  desc "Alibaba Dragonwell JDK 11 - downstream distribution of OpenJDK"
  homepage "https://www.aliyun.com/product/dragonwell"
  version "dragonwell-extended-11.0.31.28_jdk-11.0.31-ga"
  license "GPL-2.0"

  on_linux do
    on_arm do
      url "https://github.com/dragonwell-project/dragonwell11/releases/download/dragonwell-extended-11.0.31.28_jdk-11.0.31-ga/Alibaba_Dragonwell_Extended_11.0.31.28.11_aarch64_linux-sbom.json"
      sha256 "ffc1c17de56f682909cfac844dee120e6c05120efb2bcb8c3580b749e4cd44d4"
    end
    on_intel do
      url "https://github.com/dragonwell-project/dragonwell11/releases/download/dragonwell-extended-11.0.31.28_jdk-11.0.31-ga/Alibaba_Dragonwell_Extended_11.0.31.28.11_aarch64_linux-sbom.json"
      sha256 "ffc1c17de56f682909cfac844dee120e6c05120efb2bcb8c3580b749e4cd44d4"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
