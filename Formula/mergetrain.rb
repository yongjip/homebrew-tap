class Mergetrain < Formula
  include Language::Python::Virtualenv

  desc "Local deploy train for coding-agent worktrees"
  homepage "https://github.com/yongjip/mergetrain"
  url "https://files.pythonhosted.org/packages/61/fb/2ff9b38084f8d658a2a0465c0585da87b177ab37a4bf66cab36be2e164d5/mergetrain-3.0.2.tar.gz"
  sha256 "77d9ab095ce1daf3eabd04736c7452022a7e14ef6a28e86438dcc28e9808a915"
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
    assert_equal 3, payload["contract_version"]
    assert_equal true, payload["ok"]
    assert_equal "unconfigured", payload["health"]
    assert_equal version.to_s, payload.dig("diagnostics", "version") unless build.head?
  end
end
