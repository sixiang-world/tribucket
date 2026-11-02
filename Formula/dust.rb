class Dust < Formula
  desc "More intuitive version of du (disk usage)"
  homepage "https://github.com/bootandy/dust"
  version "1.2.7"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/bootandy/dust/releases/download/v1.2.7/dust-v1.2.7-x86_64-apple-darwin.tar.gz"
      sha256 "5eef77d18dfd2d1d56d1b3c415bc2d41b5b793bc63b5c7f706005d058a48a363"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bootandy/dust/releases/download/v1.2.7/dust-v1.2.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "64496fe9e56dabb379308b3a079816818f6022d0b93638d06206a9144ca795d9"
    end
    on_intel do
      url "https://github.com/bootandy/dust/releases/download/v1.2.7/dust-v1.2.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ec3bf712c660dcaa5578b996741f5cca36b30c021c1e4b49352b11137a95a96e"
    end
  end

  def install
    bin.install Dir["dust*"].first => "dust"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dust --version 2>&1", 1)
  end
end
