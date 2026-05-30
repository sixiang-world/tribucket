class Vagrant < Formula
  desc "Development environment management tool by HashiCorp"
  homepage "https://www.vagrantup.com/"
  version "2.4.6"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://releases.hashicorp.com/vagrant/2.4.6/vagrant_2.4.6_darwin_arm64.dmg"
      sha256 "0b42a3ede375c4ab93923f25d0e38142833ca1fa35a68a6f564af10ed0b80976"
    end
    on_intel do
      url "https://releases.hashicorp.com/vagrant/2.4.6/vagrant_2.4.6_darwin_amd64.dmg"
      sha256 "0b42a3ede375c4ab93923f25d0e38142833ca1fa35a68a6f564af10ed0b80976"
    end
  end

  on_linux do
    on_intel do
      url "https://releases.hashicorp.com/vagrant/2.4.6/vagrant_2.4.6_linux_amd64.zip"
      sha256 "34ebb5b731b06d3c8b462885d33b1d468d186513c4d2c3101121df9121fa34a9"
    end
  end

  def install
    bin.install Dir["vagrant*"].first => "vagrant"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vagrant --version 2>&1", 1)
  end
end
