class Mergetrain < Formula
  include Language::Python::Virtualenv

  desc "Local-first merge queue for parallel coding-agent worktrees"
  homepage "https://github.com/yongjip/mergetrain"
  url "https://files.pythonhosted.org/packages/a7/6c/bce60a8563a576a34a9e85263446225fb669a452f37ee210832b35cd096c/mergetrain-0.4.0.tar.gz"
  sha256 "4d0a7cf686c54b1931047b4c2647e5ee5826fe1d325e32b33be5ed11205e18c0"
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
