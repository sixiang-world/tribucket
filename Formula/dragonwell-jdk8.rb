class DragonwellJdk8 < Formula
  desc "Alibaba Dragonwell JDK 8 - downstream distribution of OpenJDK"
  homepage "https://www.aliyun.com/product/dragonwell"
  version "dragonwell-standard-8.29.28_jdk8u492-ga"
  license "GPL-2.0"

  on_linux do
    on_arm do
      url "https://github.com/dragonwell-project/dragonwell8/releases/download/dragonwell-standard-8.29.28_jdk8u492-ga/Alibaba_Dragonwell_Standard_8.29.28_aarch64_linux-sbom.json"
      sha256 "9916b2d6c3cffed806e6989415cfd3eb2d2069f78d9591e82ffbc9b32d0ab011"
    end
    on_intel do
      url "https://github.com/dragonwell-project/dragonwell8/releases/download/dragonwell-standard-8.29.28_jdk8u492-ga/Alibaba_Dragonwell_Standard_8.29.28_aarch64_linux-sbom.json"
      sha256 "9916b2d6c3cffed806e6989415cfd3eb2d2069f78d9591e82ffbc9b32d0ab011"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
