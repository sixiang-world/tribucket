class ZuluJdk8 < Formula
  desc "Azul Zulu JDK 8 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "8.0.502"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu8.96.0.19-ca-jdk8.0.502-macosx_aarch64.tar.gz"
      sha256 "9f9e5038c638e415e507e8b5118a774822f553a56e76bdf4b042c3fbe7b69083"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu8.96.0.19-ca-jdk8.0.502-macosx_x64.tar.gz"
      sha256 "b29088ddb00f81db1e01d6d5bfddd44a58e46ef44b50c372cff3eb1bf5b23173"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu8.96.0.19-ca-jdk8.0.502-linux_aarch64.tar.gz"
      sha256 "b23296caf10d0c3db054d4a58b9dd168976991472f2203335d7c4820f98c4a4e"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu8.96.0.19-ca-jdk8.0.502-linux_x64.tar.gz"
      sha256 "5923daaf12fd0b87e60e437aaae7b2e5b257846cdb8ac15065258fb59a1da70a"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
