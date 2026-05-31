class Icloudpd < Formula
  desc "A command-line tool to download photos from iCloud"
  homepage "https://github.com/icloud-photos-downloader/icloud_photos_downloader"
  version "1.32.3"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.32.3/icloud-1.32.3-macos-amd64"
      sha256 "b00d050ca0fc07d10d0acae884c04e5d749b626f15bc7c360a9578f2e722a65f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.32.3/icloud-1.32.3-linux-arm64"
      sha256 "98f58bad633634b3ed061f0ad5687ba95dd543946010c5b653fa71bdabf179fb"
    end
    on_intel do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.32.3/icloud-1.32.3-linux-amd64"
      sha256 "656ae6784a34e99bebea0fe144d83ead91993f071af3e674964f7c22b5b2b556"
    end
  end

  def install
    bin.install Dir["icloudpd*"].first => "icloudpd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/icloudpd --version 2>&1", 1)
  end
end
