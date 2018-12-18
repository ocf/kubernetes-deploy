#!/usr/bin/env python3
'''
Deploys Kubernetes templates from the current directory. Creates a namespace
based on the app name, and runs kubernetes-deploy.
'''

import argparse
import json
import os
import subprocess
import sys

def get_current_context():
    return subprocess.check_output(
        ['kubectl', 'config', 'current-context']
    ).decode().strip()

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('appname', help='The name of the app to deploy')
    parser.add_argument(
        'version',
        help='The version of the app, usually the docker tag.',
    )
    parser.add_argument(
        '--kube-context',
        default=get_current_context(),
        help='The Kubernetes context to use. Defaults to the current context.',
    )

    # We don't specify the default here because this gets run from within a
    # docker container, which might not be able to see the .git folder. Instead,
    # the default gets passed in by the ocf-kubernetes-deploy script.
    parser.add_argument(
        '--revision',
        help=('The Git commit hash to be deployed, required by'
            + 'kubernetes-deploy. Defaults to the current Git revision.'),
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

    env = os.environ.copy()
    if args.revision:
        env['REVISION'] = args.revision

    subprocess.run(
        [
            'kubernetes-deploy',
            namespace_name,
            args.kube_context,
            '--template-dir', '.',
            '--bindings=' + json.dumps(bindings),
        ],
        env=env,
    ).check_returncode()

if __name__ == '__main__':
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as err:
        sys.exit(err.returncode)
