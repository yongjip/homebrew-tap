class Mergetrain < Formula
  include Language::Python::Virtualenv

  desc "Local-first merge queue for parallel coding-agent worktrees"
  homepage "https://github.com/yongjip/mergetrain"
  url "https://files.pythonhosted.org/packages/3f/3c/8be0440885b58437790931d3b13413c45852591e645491676a4f5f07f7e4/mergetrain-1.4.1.tar.gz"
  sha256 "9e6daf2f3397c8de7cd24dddeed87ad99047ad229b738e30315db6f6032a26de"
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
