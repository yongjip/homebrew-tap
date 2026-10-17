class Mergetrain < Formula
  include Language::Python::Virtualenv

  desc "Queue and test branches from parallel coding-agent worktrees"
  homepage "https://github.com/yongjip/mergetrain"
  url "https://files.pythonhosted.org/packages/b4/b3/d7cebcb47c52200691e0f4dee9e31f565fb3ccc40e81ef9904020e26a04b/mergetrain-3.6.0.tar.gz"
  sha256 "e90986bfbdb0d1ad06c877f8a9f10f0d94d3cf40fec50781d40c0aaffded8f4b"
  license "MIT"

  head "https://github.com/yongjip/mergetrain.git", branch: "main"

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "mergetrain #{version}", shell_output("#{bin}/mergetrain --version")
    help = shell_output("#{bin}/mergetrain --help")
    assert_match "{init,status,enqueue,validate,deploy,inspect}", help

    # Check the stable operator contract through a public, read-only command.
    # An empty testpath is intentionally reported as unconfigured rather than
    # treated as an execution failure.
    require "json"
    status = shell_output("#{bin}/mergetrain --repo #{testpath} status --json --diagnose")
    payload = JSON.parse(status)
    assert_equal 5, payload["contract_version"]
    assert_equal true, payload["ok"]
    assert_equal "unconfigured", payload["health"]
    assert_equal version.to_s, payload.dig("diagnostics", "version") unless build.head?
  end
end
