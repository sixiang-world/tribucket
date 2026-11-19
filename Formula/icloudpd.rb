class Icloudpd < Formula
  desc "A command-line tool to download photos from iCloud"
  homepage "https://github.com/icloud-photos-downloader/icloud_photos_downloader"
  version "1.33.1"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.33.1/icloud-1.33.1-macos-amd64"
      sha256 "4e0103eb4021663d406c7a2e7893442c89e4ee8e3909978a85fdbb4d9d9dc4b6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.33.1/icloud-1.33.1-linux-arm64"
      sha256 "0ca173ff88e15572a90215d39c226a039d0393d705d70b6066681cb9b869f8ff"
    end
    on_intel do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.33.1/icloud-1.33.1-linux-amd64"
      sha256 "598fc11318a289c94ba031043987b31c311845fbaf993dbbf9fdd40ef0651582"
    end
  end

  def install
    bin.install Dir["icloudpd*"].first => "icloudpd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/icloudpd --version 2>&1", 1)
  end
end
