class DragonwellJdk17 < Formula
  desc "Alibaba Dragonwell JDK 17 - downstream distribution of OpenJDK"
  homepage "https://www.aliyun.com/product/dragonwell"
  version "dragonwell-standard-17.0.20.0.21+8_jdk-17.0.20-ga"
  license "GPL-2.0"

  on_linux do
    on_arm do
      url "https://github.com/dragonwell-project/dragonwell17/releases/download/dragonwell-standard-17.0.20.0.21%2B8_jdk-17.0.20-ga/Alibaba_Dragonwell_Standard_17.0.20.0.21.8_aarch64_linux-sbom.json"
      sha256 "6e4597801065e6f80b896aec7e7f1a59753e92cfba8b77a4a27ef1797a9a6fc4"
    end
    on_intel do
      url "https://github.com/dragonwell-project/dragonwell17/releases/download/dragonwell-standard-17.0.20.0.21%2B8_jdk-17.0.20-ga/Alibaba_Dragonwell_Standard_17.0.20.0.21.8_aarch64_linux-sbom.json"
      sha256 "6e4597801065e6f80b896aec7e7f1a59753e92cfba8b77a4a27ef1797a9a6fc4"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
