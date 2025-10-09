#!/usr/bin/env python3
import sys
import json
import textwrap

# Lecture du JSON depuis l'entrée standard (ex: `tsh get nodes --format json | python3 script.py`)
items = json.load(sys.stdin)

for item in items:
    domain = item.get("cluster", "")

    # Lecture du nœud
    node = item["node"]
    hostname = node["spec"]["hostname"]
    labels = node["metadata"].get("labels", {})

    # Construction des tags
    tags = ", ".join(f"{k}: {v}" for k, v in labels.items()) or "none"

    # Sortie SSH config
    output = textwrap.dedent(f"""\
    # Tags: {tags}
    Host {hostname}.{domain}
    HostName {hostname}.{domain}
    User root
    """)
    print(output)
