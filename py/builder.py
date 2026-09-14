#!/usr/bin/env python3
import subprocess


subprocess.run(["dart", "run", "build_runner", "build"], check=True)
