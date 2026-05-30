class Terraform < Formula
  desc "Infrastructure as Code tool by HashiCorp"
  homepage "https://www.terraform.io/"
  version "1.15.5"
  license "BSL-1.1"

  on_macos do
    on_arm do
      url "https://releases.hashicorp.com/terraform/1.15.5/terraform_1.15.5_darwin_arm64.zip"
      sha256 "01137660510005b918bba82154866fbeac4393163d8277c2abe861dfb5842c3c"
    end
    on_intel do
      url "https://releases.hashicorp.com/terraform/1.15.5/terraform_1.15.5_darwin_amd64.zip"
      sha256 "3687d07c034b3e7deed5b072cd8ae2b34835bcb139baec3fc4f5fd534dabf5ed"
    end
  end

  on_linux do
    on_arm do
      url "https://releases.hashicorp.com/terraform/1.15.5/terraform_1.15.5_linux_arm64.zip"
      sha256 "06e7b48de826146c6d9331ba35b13da12332d8392be30d1dd6b789ba4713fff0"
    end
    on_intel do
      url "https://releases.hashicorp.com/terraform/1.15.5/terraform_1.15.5_linux_amd64.zip"
      sha256 "702b2136af6728c8ff037f843dd2dbce2b7ad88786b7381d1d72aefa250f601c"
    end
  end

  def install
    bin.install Dir["terraform*"].first => "terraform"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraform --version 2>&1", 1)
  end
end
