#!/usr/bin/env python3
"""Remove the macOS Intel debug printf lines from .cnb.yml (two occurrences)."""
with open('.cnb.yml', 'r') as f:
    lines = f.readlines()
with open('.cnb.yml', 'w') as f:
    for line in lines:
        if 'printf' in line and 'darwin-amd64-debug' in line:
            print(f'Skipping: {line.strip()}')
            continue
        f.write(line)
print('Done - CNB fixed')
