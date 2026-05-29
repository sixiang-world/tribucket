class Duf < Formula
  desc "Better df alternative - disk usage/free utility"
  homepage "https://github.com/muesli/duf"
  version "0.9.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/muesli/duf/releases/download/v0.9.1/duf_0.9.1_darwin_arm64.tar.gz"
      sha256 "512ba0ff3585bb8c65841de557a4c4b8712332db005dc952fa98d373a05d01df"
    end
    on_intel do
      url "https://github.com/muesli/duf/releases/download/v0.9.1/duf_0.9.1_darwin_x86_64.tar.gz"
      sha256 "e3384519b0055c904b7352b55cd81bd101f5dd94dab1195a72880bddca7c2aaf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/muesli/duf/releases/download/v0.9.1/duf_0.9.1_linux_arm64.tar.gz"
      sha256 "22ea0ad29f6610bf443aa351e600de97e47a9b380ef58316606a84bb8f595216"
    end
    on_intel do
      url "https://github.com/muesli/duf/releases/download/v0.9.1/duf_0.9.1_linux_x86_64.tar.gz"
      sha256 "5add851e7062c5e56939abb664705e4d14fa2d06289490aff31d51f153832de7"
    end
  end

  def install
    bin.install Dir["duf*"].first => "duf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duf --version 2>&1", 1)
  end
end
