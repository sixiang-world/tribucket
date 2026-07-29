class Czkawka < Formula
  desc "Multi functional app to find duplicates, empty folders, similar images etc."
  homepage "https://github.com/qarmin/czkawka"
  version "12.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/qarmin/czkawka/releases/download/12.0.1/mac_czkawka_cli_arm64"
      sha256 "465ba2ea8f6ce0378adc412e7d8012903e8bfc6d3bded29320db3ed02723c905"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/qarmin/czkawka/releases/download/12.0.1/linux_czkawka_cli_arm64"
      sha256 "82bcbb671b1cd833e0ecbdd57a39c1e729880fb1bc938ba6075d8d9a771d96d9"
    end
    on_intel do
      url "https://github.com/qarmin/czkawka/releases/download/12.0.1/linux_czkawka_cli_x86_64"
      sha256 "612fdb68c245775b02c34cb52aa7a350ea89cd11fe7a3daf7fd947a26a679d2b"
    end
  end

  def install
    bin.install Dir["czkawka_cli*"].first => "czkawka_cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/czkawka_cli --version 2>&1", 1)
  end
end
