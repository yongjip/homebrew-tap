class Mergetrain < Formula
  include Language::Python::Virtualenv

  desc "Local-first merge queue for parallel coding-agent worktrees"
  homepage "https://github.com/yongjip/mergetrain"
  url "https://files.pythonhosted.org/packages/f0/6b/4dcddab2b9a6aec61c59b15d2f4ae66b9b1fd11940234ea99f5d80cfc6da/mergetrain-1.4.2.tar.gz"
  sha256 "4054be2ff5a8725384184f801bfa17b0d1d4b4a6a2cad2fa1c17ee6ee3373e11"
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
