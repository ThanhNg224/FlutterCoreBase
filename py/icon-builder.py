#!/usr/bin/env python3
import subprocess


subprocess.run(["flutter", "pub", "get"], check=True)
subprocess.run(["dart", "run", "icons_launcher:create"], check=True)
