class Icloudpd < Formula
  desc "A command-line tool to download photos from iCloud"
  homepage "https://github.com/icloud-photos-downloader/icloud_photos_downloader"
  version "1.32.2"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.32.2/icloudpd-1.32.2-macos-amd64"
      sha256 "ba367ccd7aec4c8e7cbbee064655e3a982acc549ffd35dcdf5a2f861065a0e21"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.32.2/icloudpd-1.32.2-linux-arm64"
      sha256 "b0558688afbc3938c385bd0fe459349543eec452266843a7ec50cc98cbd3b3b2"
    end
    on_intel do
      url "https://github.com/icloud-photos-downloader/icloud_photos_downloader/releases/download/v1.32.2/icloudpd-1.32.2-linux-amd64"
      sha256 "292e639a4ddb01e81c642cb17484b2f5f848700ef55825ac111f2d2cd1b3ba76"
    end
  end

  def install
    bin.install Dir["icloudpd*"].first => "icloudpd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/icloudpd --version 2>&1", 1)
  end
end
