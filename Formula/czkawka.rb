class Czkawka < Formula
  desc "Multi functional app to find duplicates, empty folders, similar images etc."
  homepage "https://github.com/qarmin/czkawka"
  version "12.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/qarmin/czkawka/releases/download/12.0.0/mac_czkawka_cli_arm64"
      sha256 "9a08888d329fe39d5b00a15bf0bbbfdc80c5f480465edc63a94a13a3b4e1f312"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/qarmin/czkawka/releases/download/12.0.0/linux_czkawka_cli_arm64"
      sha256 "2d7a66cf626d64ae578e2ef502df5ea9e82aeab3d890853a2e15118c430d8a37"
    end
    on_intel do
      url "https://github.com/qarmin/czkawka/releases/download/12.0.0/linux_czkawka_cli_x86_64"
      sha256 "ad21a5428aee09fad88fb6d35fb1c656b9e0b8cdafee2de107618ddb5a9997ff"
    end
  end

  def install
    bin.install Dir["czkawka_cli*"].first => "czkawka_cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/czkawka_cli --version 2>&1", 1)
  end
end
