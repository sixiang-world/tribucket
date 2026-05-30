class Czkawka < Formula
  desc "Multi functional app to find duplicates, empty folders, similar images etc."
  homepage "https://github.com/qarmin/czkawka"
  version "11.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/qarmin/czkawka/releases/download/11.0.1/mac_czkawka_cli_arm64"
      sha256 "62895a4873c79516a7c07d3fbfdc7fda1f7ff806d589558e40f56c7e959828a3"
    end
    on_intel do
      url "https://github.com/qarmin/czkawka/releases/download/11.0.1/mac_czkawka_cli_x86_64"
      sha256 "ed360781c1da7b5596ba05feeaf87ea18f46f2125b4fdb4feb4fbac6ddb5d418"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/qarmin/czkawka/releases/download/11.0.1/linux_czkawka_cli_arm64"
      sha256 "eb333e3b29d576db6d2365cd9deff454cfc9e7bc9b8b6dfefb4ab82b14db7dc8"
    end
    on_intel do
      url "https://github.com/qarmin/czkawka/releases/download/11.0.1/linux_czkawka_cli_x86_64"
      sha256 "2f81d63f79047294629253f4232c47cf5a2c6e55b9e34f23d11c2c810cfcbc09"
    end
  end

  def install
    bin.install Dir["czkawka_cli*"].first => "czkawka_cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/czkawka_cli --version 2>&1", 1)
  end
end
