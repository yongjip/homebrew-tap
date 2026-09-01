class Mergetrain < Formula
  include Language::Python::Virtualenv

  desc "Local-first merge queue for parallel coding-agent worktrees"
  homepage "https://github.com/yongjip/mergetrain"
  url "https://files.pythonhosted.org/packages/bf/6a/ff019a33912e4f886d5547a1b91c77cfc3233854fd4257b0cd4ab2a5c8e8/mergetrain-2.1.0.tar.gz"
  sha256 "0cb36a0c1e9ccd67ba792c883e7a870677367893bea4d72f53260e263e304a7f"
  license "MIT"

  head "https://github.com/yongjip/mergetrain.git", branch: "main"

  depends_on "libyaml"
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
    assert_equal 2, payload["contract_version"]
    assert_equal true, payload["ok"]
    assert_equal version.to_s, payload["version"] unless build.head?
  end
end
