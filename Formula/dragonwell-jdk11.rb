class DragonwellJdk11 < Formula
  desc "Alibaba Dragonwell JDK 11 - downstream distribution of OpenJDK"
  homepage "https://www.aliyun.com/product/dragonwell"
  version "dragonwell-standard-11.0.32.28_jdk-11.0.32-ga"
  license "GPL-2.0"

  on_linux do
    on_arm do
      url "https://github.com/dragonwell-project/dragonwell11/releases/download/dragonwell-standard-11.0.32.28_jdk-11.0.32-ga/Alibaba_Dragonwell_Standard_11.0.32.28.9_aarch64_linux.tar.gz"
      sha256 "c81c16e34c7ba8030c4a7c18559ac490191960e9a010d72b5b61cf159210ca94"
    end
    on_intel do
      url "https://github.com/dragonwell-project/dragonwell11/releases/download/dragonwell-standard-11.0.32.28_jdk-11.0.32-ga/Alibaba_Dragonwell_Standard_11.0.32.28.9_x64_linux.tar.gz"
      sha256 "a2b9cea8d446b70b1a539e10c9131a87b5a7749a0ca2f77debd895c36990871b"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
