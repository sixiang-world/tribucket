class Icloudpd < Formula
  desc "A command-line tool to download photos from iCloud"
  homepage "https://github.com/icloud-photos-downloader/icloud_photos_downloader"
  version "1.34.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.34.0/icloud-1.34.0-macos-amd64"
      sha256 "502ae61035acbf6817c88e8bec24db3fe493b305c29861e1f809ace3a54269bf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.34.0/icloud-1.34.0-linux-arm64"
      sha256 "25fb2d6621186ff93f0b5f4a43387fafc6b229f1223c21ce5eef8068d8fea499"
    end
    on_intel do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.34.0/icloud-1.34.0-linux-amd64"
      sha256 "7118c06638b9190fc51ff27fc385ebb914490ae3b2e7bf6917c91cc45b128288"
    end
  end

  def install
    bin.install Dir["icloudpd*"].first => "icloudpd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/icloudpd --version 2>&1", 1)
  end
end
