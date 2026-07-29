class Mergetrain < Formula
  include Language::Python::Virtualenv

  desc "Local-first merge queue for parallel coding-agent worktrees"
  homepage "https://github.com/yongjip/mergetrain"
  url "https://files.pythonhosted.org/packages/65/67/6994e04836ef328337ae4747c4817ede3d8b4c12e9e71481418a4178743f/mergetrain-1.1.0.tar.gz"
  sha256 "3b2eca626cd935b84d9dd654a40920df002565063119e149a774e0489c715762"
  license "MIT"

  head "https://github.com/yongjip/mergetrain.git", branch: "main"

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "mergetrain #{version}", shell_output("#{bin}/mergetrain --version")
    assert_match "agent contract", shell_output("#{bin}/mergetrain agent-contract")

    # mergetrain's whole interface for agents is versioned JSON, so a formula
    # that installs a runnable binary is not enough: check the machine contract
    # the same way a consumer would, and that the reported version is the
    # version this formula claims to have built.
    require "json"
    payload = JSON.parse(shell_output("#{bin}/mergetrain version --json"))
    assert_equal 1, payload["contract_version"]
    assert_equal true, payload["ok"]
    assert_equal version.to_s, payload["version"] unless build.head?
  end
end
