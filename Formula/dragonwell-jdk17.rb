class DragonwellJdk17 < Formula
  desc "Alibaba Dragonwell JDK 17 - downstream distribution of OpenJDK"
  homepage "https://www.aliyun.com/product/dragonwell"
  version "dragonwell-standard-17.0.19.0.20+10_jdk-17.0.19-ga"
  license "GPL-2.0"

  on_linux do
    on_arm do
      url "https://github.com/dragonwell-project/dragonwell17/releases/download/dragonwell-standard-17.0.19.0.20%2B10_jdk-17.0.19-ga/Alibaba_Dragonwell_Standard_17.0.19.0.20.10_aarch64_linux-sbom.json"
      sha256 "b2fddd023d85762a971de934072a00b0dc059d76046e347e8c3a3c3c1ee3254e"
    end
    on_intel do
      url "https://github.com/dragonwell-project/dragonwell17/releases/download/dragonwell-standard-17.0.19.0.20%2B10_jdk-17.0.19-ga/Alibaba_Dragonwell_Standard_17.0.19.0.20.10_aarch64_linux-sbom.json"
      sha256 "b2fddd023d85762a971de934072a00b0dc059d76046e347e8c3a3c3c1ee3254e"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
