class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.16.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.5/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "ed142f8656e0092828c103dd058b55b871c88e13a801cade8f860d8a9ca8943e"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.5/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "4895245fe294cd9f38b8c941b9aa009b3015729f73327bdbf8a716b7fec8f84d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.5/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "796079ea998dba3e455394077ba51a4c500c2402d3920580c646a0580f20370c"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.5/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "65b8bae7e43f12a91b71036a52176012b3aefb725d5ae263e2771474110a0983"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
