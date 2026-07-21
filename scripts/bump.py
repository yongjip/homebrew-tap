#!/usr/bin/env python3
"""Rewrite a formula's url/sha256 to the latest sdist on PyPI.

Idempotent: exits quietly when the formula already points at the latest
release, so the workflow's commit step can key off `git diff`.
"""

from __future__ import annotations

import json
import re
import sys
import urllib.request
from pathlib import Path


def main() -> int:
    formula_path = Path(sys.argv[1])
    package = sys.argv[2]

    with urllib.request.urlopen(f"https://pypi.org/pypi/{package}/json", timeout=30) as fh:
        data = json.load(fh)
    version = data["info"]["version"]
    sdist = next(u for u in data["urls"] if u["packagetype"] == "sdist")
    url = sdist["url"]
    sha256 = sdist["digests"]["sha256"]

    text = formula_path.read_text(encoding="utf-8")
    if url in text and sha256 in text:
        print(f"{package} {version}: formula already current")
        return 0

    new_text = re.sub(r'^(\s*)url ".*"$', rf'\1url "{url}"', text, count=1, flags=re.M)
    new_text = re.sub(
        r'^(\s*)sha256 ".*"$', rf'\1sha256 "{sha256}"', new_text, count=1, flags=re.M
    )
    if new_text == text:
        raise SystemExit(f"could not rewrite url/sha256 lines in {formula_path}")
    formula_path.write_text(new_text, encoding="utf-8")
    print(f"{package}: bumped to {version}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
