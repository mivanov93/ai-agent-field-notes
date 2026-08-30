#!/usr/bin/env python3
"""Regenerate _data/nav.yml (the site sidebar) from README.md.

README.md stays the source of truth for what exists and in what order. The
sidebar is derived from its section tables so the two cannot drift: add,
remove, or reorder a finding in the README, then run this.

    python3 script/build-nav.py
"""
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ENTRY = re.compile(r'^\|\s*(★|↳)?\s*\[([^\]]+)\]\(([^)]+)\.md\)\s*\|')


def esc(s):
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"') + '"'


def main():
    src = open(os.path.join(ROOT, 'README.md'), encoding='utf-8').read()
    section, sections, order = None, {}, []

    for line in src.split('\n'):
        heading = re.match(r'^##\s+(.*)$', line)
        if heading:
            section = heading.group(1).strip()
            if section not in sections:
                sections[section] = []
                order.append(section)
            continue
        entry = ENTRY.match(line)
        if entry and section:
            sections[section].append(entry.groups())

    out = [
        "# The sidebar. GENERATED FROM README.md's section tables — the README stays",
        "# the source of truth for what exists and in what order. Regenerate with",
        "#   python3 script/build-nav.py",
        "# after adding, removing, or reordering a finding.",
        "",
    ]
    total = 0
    for section in order:
        if not sections[section]:
            continue
        label, _, note = section.partition('—')
        out.append(f"- section: {esc(label.strip())}")
        if note.strip():
            out.append(f"  note: {esc(note.strip())}")
        out.append("  items:")
        for mark, title, href in sections[section]:
            url = href + '.md'
            # A folder README renders as the folder's index page, so the
            # sidebar links the folder, not a README.html that never exists.
            if url.endswith('/README.md'):
                url = url[:-len('README.md')]
            out.append(f"    - title: {esc(title)}")
            out.append(f"      url: {esc(url)}")
            if mark == '★':
                out.append("      original: true")
            if mark == '↳':
                out.append("      extends: true")
            total += 1
    out.append("")

    os.makedirs(os.path.join(ROOT, '_data'), exist_ok=True)
    with open(os.path.join(ROOT, '_data/nav.yml'), 'w', encoding='utf-8') as f:
        f.write('\n'.join(out))
    print(f"_data/nav.yml — {len([s for s in order if sections[s]])} sections, {total} entries")


if __name__ == '__main__':
    main()
