class DragonwellJdk8 < Formula
  desc "Alibaba Dragonwell JDK 8 - downstream distribution of OpenJDK"
  homepage "https://www.aliyun.com/product/dragonwell"
  version "dragonwell-standard-8.30.29_jdk8u502-ga"
  license "GPL-2.0"

  on_linux do
    on_arm do
      url "https://github.com/dragonwell-project/dragonwell8/releases/download/dragonwell-standard-8.30.29_jdk8u502-ga/Alibaba_Dragonwell_Standard_8.30.29_aarch64_linux-sbom.json"
      sha256 "80c58fe1233ed46e8963adfc8b9994e058cc7e3d0603d36bfac82a744e421364"
    end
    on_intel do
      url "https://github.com/dragonwell-project/dragonwell8/releases/download/dragonwell-standard-8.30.29_jdk8u502-ga/Alibaba_Dragonwell_Standard_8.30.29_aarch64_linux-sbom.json"
      sha256 "80c58fe1233ed46e8963adfc8b9994e058cc7e3d0603d36bfac82a744e421364"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
