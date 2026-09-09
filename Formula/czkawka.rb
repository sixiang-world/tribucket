class Czkawka < Formula
  desc "Multi functional app to find duplicates, empty folders, similar images etc."
  homepage "https://github.com/qarmin/czkawka"
  version "12.0.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/qarmin/czkawka/releases/download/12.0.2/mac_czkawka_cli_arm64"
      sha256 "3362df5776b209b6365482768bc960e5a853f1b554787954c4a4c64e90bc2c75"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/qarmin/czkawka/releases/download/12.0.2/linux_czkawka_cli_arm64"
      sha256 "3a65408ca30036cf1cd993112bde6288e13c870842d12131dee8b4e435325c38"
    end
    on_intel do
      url "https://github.com/qarmin/czkawka/releases/download/12.0.2/linux_czkawka_cli_x86_64"
      sha256 "61e7e8ac3f42338957ddc0739df653b9df6ff2958cab3b4cce14663b39c40843"
    end
  end

  def install
    bin.install Dir["czkawka_cli*"].first => "czkawka_cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/czkawka_cli --version 2>&1", 1)
  end
end
