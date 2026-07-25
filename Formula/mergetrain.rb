class Mergetrain < Formula
  include Language::Python::Virtualenv

  desc "Local-first merge queue for parallel coding-agent worktrees"
  homepage "https://github.com/yongjip/mergetrain"
  url "https://files.pythonhosted.org/packages/3d/12/7a1dd8bed9da1747941082d5010a9f0e1167fe5bdaa940735bf50dd3ed84/mergetrain-0.8.1.tar.gz"
  sha256 "83a915bde47178c1c6f03c8bf45e07de22fcc45389d9712d7bb2e5aa720c3648"
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
