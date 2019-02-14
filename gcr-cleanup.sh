#!/bin/bash

# Copyright © 2017 Google Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

IFS=$'\n\t'
set -eou pipefail

if [[ "$#" -ne 2 || "${1}" == '-h' || "${1}" == '--help' ]]; then
  cat >&2 <<"EOF"
gcrgc.sh cleans up tagged or untagged images for a given repository and keeps the last N (an image name without a tag/digest).
USAGE:
  gcrgc.sh REPOSITORY KEEP
EXAMPLE
  gcrgc.sh gcr.io/ahmet/my-app 3
  would clean up everything under the gcr.io/ahmet/my-app repository
  and keep the latest 3 images.
EOF
  exit 1
fi

main(){
  local C=0
  REPOSITORY="${1}"
  KEEP="${2}"
  for digest in $(gcloud container images list-tags ${REPOSITORY} --limit=999999 --sort-by=~TIMESTAMP \
    --format='get(digest)'); do
    if [[ $C -ge $KEEP ]]; then
      (
        set -x
        gcloud container images delete -q --force-delete-tags "${REPOSITORY}@${digest}"
      )
    fi
    let C=C+1
  done
  local D
  let D=C-KEEP
  echo "Deleted ${D} images in ${REPOSITORY}." >&2
}

main "${1}" ${2}
