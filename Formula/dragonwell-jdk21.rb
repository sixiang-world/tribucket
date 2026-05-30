class DragonwellJdk21 < Formula
  desc "Alibaba Dragonwell - downstream distribution of OpenJDK"
  homepage "https://www.aliyun.com/product/dragonwell"
  version "21.0.11.0.11+10"
  license "GPL-2.0"

  on_linux do
    on_arm do
      url "https://github.com/dragonwell-project/dragonwell21/releases/download/dragonwell-extended-21.0.11.0.11%2B10_jdk-21.0.11-ga/Alibaba_Dragonwell_Extended_21.0.11.0.11.10_aarch64_linux.tar.gz"
      sha256 "326cee2bffa56f255ccc6b581904c91e3c5cd7b28cc2eb20afb0531cf476f94d"
    end
    on_intel do
      url "https://github.com/dragonwell-project/dragonwell21/releases/download/dragonwell-extended-21.0.11.0.11%2B10_jdk-21.0.11-ga/Alibaba_Dragonwell_Extended_21.0.11.0.11.10_x64_linux.tar.gz"
      sha256 "12c642f8d6c6e0930b9b4e673d47822227ea46e7559c7b7b6b4c0331ace0580f"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
