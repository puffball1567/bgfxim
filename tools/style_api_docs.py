#!/usr/bin/env python3
# SPDX-License-Identifier: BSD-2-Clause
"""Apply the bgfxim documentation theme to Nim's generated HTML."""

from __future__ import annotations

import argparse
import html
import re
import shutil
from pathlib import Path
from urllib.parse import unquote, urlsplit


PROJECT_ROOT = Path(__file__).resolve().parents[1]
THEME_SOURCE = PROJECT_ROOT / "docs" / "assets"
THEME_FILES = ("api-docs.css", "api-docs.js")
LOCAL_REFERENCE = re.compile(r"(?:href|src)=(?:\"([^\"]+)\"|'([^']+)')")


def relative_asset_prefix(page: Path, output_directory: Path) -> str:
    depth = len(page.relative_to(output_directory).parents) - 1
    return "../" * depth + "assets/"


def decorate_html(source: str, asset_prefix: str) -> str:
    source = re.sub(
        r"\n<!-- Google fonts -->\n(?:<link[^>]+fonts\.googleapis\.com[^>]+/>\n?)+",
        "\n",
        source,
    )
    source = re.sub(
        r"<title>.*?</title>",
        "<title>bgfxim API Reference</title>",
        source,
        count=1,
        flags=re.DOTALL,
    )
    source = source.replace(
        '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
        '<meta name="viewport" content="width=device-width, initial-scale=1.0">\n'
        '<meta name="description" content="Complete Nim API reference for bgfx">',
        1,
    )
    stylesheet = (
        f'<link rel="stylesheet" type="text/css" '
        f'href="{asset_prefix}api-docs.css">'
    )
    source = source.replace("</head>", stylesheet + "\n</head>", 1)
    source = source.replace(
        "<body>", '<body class="bgfxim-docs" data-api-version="155">', 1
    )
    script = f'<script defer src="{asset_prefix}api-docs.js"></script>'
    source = source.replace("</body>", script + "\n</body>", 1)
    return source


def validate_local_links(output_directory: Path) -> None:
    missing: list[str] = []
    for page in sorted(output_directory.rglob("*.html")):
        source = page.read_text(encoding="utf-8")
        for double_quoted, single_quoted in LOCAL_REFERENCE.findall(source):
            reference = html.unescape(double_quoted or single_quoted)
            parsed = urlsplit(reference)
            if parsed.scheme or parsed.netloc or not parsed.path:
                continue
            target = (page.parent / unquote(parsed.path)).resolve()
            if target.is_dir():
                target /= "index.html"
            if not target.is_file():
                missing.append(
                    f"{page.relative_to(output_directory)} -> {parsed.path}"
                )
    if missing:
        raise ValueError("broken local documentation links: " + ", ".join(missing))


def style_output(output_directory: Path, theme_source: Path = THEME_SOURCE) -> None:
    output_directory = output_directory.resolve()
    entrypoint = output_directory / "bgfx.html"
    if not entrypoint.is_file():
        raise ValueError(f"missing Nim documentation entrypoint: {entrypoint}")

    asset_directory = output_directory / "assets"
    asset_directory.mkdir(parents=True, exist_ok=True)
    for filename in THEME_FILES:
        source = theme_source / filename
        if not source.is_file():
            raise ValueError(f"missing documentation theme asset: {source}")
        shutil.copy2(source, asset_directory / filename)

    pages = sorted(output_directory.rglob("*.html"))
    if not pages:
        raise ValueError("Nim did not produce any HTML pages")
    for page in pages:
        decorated = decorate_html(
            page.read_text(encoding="utf-8"),
            relative_asset_prefix(page, output_directory),
        )
        page.write_text(decorated, encoding="utf-8")

    shutil.copy2(entrypoint, output_directory / "index.html")
    (output_directory / ".nojekyll").write_text("", encoding="utf-8")

    required = (
        "index.html",
        "bgfx.html",
        "bgfx/defines.html",
        "theindex.html",
        "dochack.js",
        "nimdoc.out.css",
        "assets/api-docs.css",
        "assets/api-docs.js",
        ".nojekyll",
    )
    missing = [name for name in required if not (output_directory / name).is_file()]
    if missing:
        raise ValueError("incomplete API reference: " + ", ".join(missing))
    validate_local_links(output_directory)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("output_directory", type=Path)
    arguments = parser.parse_args()
    style_output(arguments.output_directory)


if __name__ == "__main__":
    main()
