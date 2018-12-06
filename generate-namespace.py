#!/usr/bin/env python3

import json
import sys

j = {
    'apiVersion': 'v1',
    'kind': 'Namespace',
    'metadata': {'name': sys.argv[1]},
}

print(json.dumps(j))
