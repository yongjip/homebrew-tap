class Mergetrain < Formula
  include Language::Python::Virtualenv

  desc "Local-first merge queue for parallel coding-agent worktrees"
  homepage "https://github.com/yongjip/mergetrain"
  url "https://files.pythonhosted.org/packages/ce/8c/36f15866848026b2839d19f271118a922f896895cac41cad7cd6af2020fc/mergetrain-0.7.0.tar.gz"
  sha256 "03fd99bfe4dc9e07d8bff033e9d1c541f899201f5fe348a16ff4185040f1cffd"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "mergetrain #{version}", shell_output("#{bin}/mergetrain --version")
    assert_match "agent contract", shell_output("#{bin}/mergetrain agent-contract")
  end
end
