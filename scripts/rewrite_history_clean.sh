#!/bin/bash
set -euo pipefail

GIT="C:/Program Files/Git/cmd/git.exe"
export GIT_AUTHOR_NAME="max124vip-dev"
export GIT_AUTHOR_EMAIL="224979425+max124vip-dev@users.noreply.github.com"
export GIT_COMMITTER_NAME="max124vip-dev"
export GIT_COMMITTER_EMAIL="224979425+max124vip-dev@users.noreply.github.com"

cd "/d/WIF Crack/WifCrackCuda v5.3 12.08.26/mldsa-gpu-verify"

"$GIT" checkout --orphan fresh-main
"$GIT" add -A
TREE=$("$GIT" write-tree)
cat > /tmp/mldsa_commit_msg.txt <<'EOF'
MLDSA-GPU Verify public showcase v0.2.0-eval

Documentation, evaluation license, API header, quick-test scripts.
EOF
COMMIT=$("$GIT" commit-tree "$TREE" -F /tmp/mldsa_commit_msg.txt)
"$GIT" reset --hard "$COMMIT"
"$GIT" branch -M main

# Remove filter-branch backup refs if present
"$GIT" for-each-ref --format='%(refname)' refs/original | while read -r ref; do
  "$GIT" update-ref -d "$ref" || true
done

"$GIT" reflog expire --expire=now --all
"$GIT" gc --prune=now --aggressive

echo "New HEAD: $("$GIT" rev-parse HEAD)"
"$GIT" log -1 --format='%B'
