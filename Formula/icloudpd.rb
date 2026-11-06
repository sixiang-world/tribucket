class Icloudpd < Formula
  desc "A command-line tool to download photos from iCloud"
  homepage "https://github.com/icloud-photos-downloader/icloud_photos_downloader"
  version "1.33.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.33.0/icloud-1.33.0-macos-amd64"
      sha256 "9d7fdd13962844072bc86a78e1d97d6b4b672e6c014f75e8ce002541ce6b1ae2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.33.0/icloud-1.33.0-linux-arm64"
      sha256 "8b520ac6d6defb702531394d343a954ae9814d454476215f40ed728ceef98dcb"
    end
    on_intel do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.33.0/icloud-1.33.0-linux-amd64"
      sha256 "d47f43b96fa3d714624813ca932d2023811b3e78aeaa6979abd06e1cda500d21"
    end
  end

  def install
    bin.install Dir["icloudpd*"].first => "icloudpd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/icloudpd --version 2>&1", 1)
  end
end
