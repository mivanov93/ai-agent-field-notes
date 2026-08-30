#!/usr/bin/env python3
"""Stamp every note with its dates, from git — never by hand.

Each note listed in README.md's section tables (plus the-story.md) gets
an italic line under its title: *Written <date>.* or *Written <date> ·
last amended <date>.* The README tables gain a trailing Written column.

created = the commit that first added the file (rename-following);
amended = the newest commit (or the working tree, when dirty) where the
file changed in anything BESIDES this stamp line — so stamping, and the
commit that ships the stamps, never counts as an amendment and the
dates cannot drift on their own. Idempotent; re-run any time. The ship
checklist runs it right before committing a note.

    python3 script/build-dates.py
"""
import datetime
import os
import re
import subprocess

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ENTRY = re.compile(r'^\|\s*(?:★|↳)?\s*\[[^\]]+\]\(([^)]+\.md)\)\s*\|')
STAMP = re.compile(r'^\*Written \d{4}-\d{2}-\d{2}')
STAMP_DIFF = re.compile(r'^[+-]\*Written \d{4}-\d{2}-\d{2}')
EXTRA = ['the-story.md']


def git(*args):
    return subprocess.run(
        ['git', *args], cwd=ROOT, capture_output=True, text=True
    ).stdout


def content_changed(diff):
    """True if the diff touches anything besides the stamp line and the
    blank line inserted with it."""
    for l in diff.split('\n'):
        if l.startswith(('+++', '---')):
            continue
        if (l[:1] in ('+', '-') and l.rstrip() not in ('+', '-')
                and not STAMP_DIFF.match(l)):
            return True
    return False


def dates(path):
    today = datetime.date.today().isoformat()
    if not git('ls-files', '--', path).strip():
        return today, today
    added = git('log', '--follow', '--diff-filter=A', '--format=%as',
                '--', path).strip()
    created = added.splitlines()[-1] if added else today
    if content_changed(git('diff', 'HEAD', '--', path)):
        return created, today
    amended = created
    stream = git('log', '--follow', '-p', '--format=%x01%as', '--', path)
    for block in stream.split('\x01')[1:]:
        date, _, diff = block.partition('\n')
        if content_changed(diff):
            amended = date.strip()
            break
    return created, amended


def stamp_note(path):
    full = os.path.join(ROOT, path)
    created, amended = dates(path)
    line = (f"*Written {created}.*" if created == amended
            else f"*Written {created} · last amended {amended}.*")
    lines = open(full, encoding='utf-8').read().split('\n')
    for i, l in enumerate(lines):
        if STAMP.match(l):
            if lines[i] == line:
                return False
            lines[i] = line
            break
    else:
        for i, l in enumerate(lines):
            if l.startswith('# '):
                lines.insert(i + 1, '')
                lines.insert(i + 2, line)
                break
        else:
            return False
    open(full, 'w', encoding='utf-8').write('\n'.join(lines))
    return True


def main():
    readme_path = os.path.join(ROOT, 'README.md')
    src = open(readme_path, encoding='utf-8').read().split('\n')
    notes, out, prev_header = [], [], False
    for l in src:
        entry = ENTRY.match(l)
        if l.rstrip() == '| Finding | One line |':
            out.append('| Finding | One line | Written |')
            prev_header = True
            continue
        if prev_header and re.match(r'^\|-+\|-+\|$', l.rstrip()):
            out.append(l.rstrip() + '---|')
            prev_header = False
            continue
        prev_header = False
        if entry:
            note = entry.group(1)
            notes.append(note)
            created, _ = dates(note)
            cell = re.search(r'\|\s*\d{4}-\d{2}-\d{2}\s*\|\s*$', l)
            if cell:
                l = l[:cell.start()] + f'| {created} |'
            else:
                l = l.rstrip() + f' {created} |'
        out.append(l)
    open(readme_path, 'w', encoding='utf-8').write('\n'.join(out))

    stamped = sum(stamp_note(n) for n in notes + EXTRA)
    print(f"README: {len(notes)} rows dated; notes: {stamped} stamped/updated, "
          f"{len(notes) + len(EXTRA) - stamped} already current")


if __name__ == '__main__':
    main()
