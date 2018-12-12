#!/usr/bin/env python3

import argparse
import json
import subprocess
import sys

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('appname', help='The name of the app to deploy')
    parser.add_argument(
        'version',
        help='The version of the app, usually the docker tag.'
    )
    args = parser.parse_args()

    namespace_name = 'app-' + args.appname

    j = {
        'apiVersion': 'v1',
        'kind': 'Namespace',
        'metadata': {'name': namespace_name},
    }

    subprocess.run(
        ['kubectl', 'apply', '-f', '-'],
        input=json.dumps(j).encode(),
    ).check_returncode()

    bindings = {
        'version': args.version,
    }

    subprocess.run(
        ['kubernetes-deploy', namespace_name, 'k8s',
        '--template-dir', '.', '--bindings='+json.dumps(bindings)]
    ).check_returncode()

if __name__ == '__main__':
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as err:
        sys.exit(err.returncode)
