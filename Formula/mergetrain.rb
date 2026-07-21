class Mergetrain < Formula
  include Language::Python::Virtualenv

  desc "Local-first merge queue for parallel coding-agent worktrees"
  homepage "https://github.com/yongjip/mergetrain"
  url "https://files.pythonhosted.org/packages/8b/46/b30499789f05b2be325454ec62b0b1c5b56d526199acc58af23cb464bbf0/mergetrain-0.5.0.tar.gz"
  sha256 "ce6f5c5290be6960dbcab6cc05adc7f1028000d6b72b21798a3020d0973576f7"
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
