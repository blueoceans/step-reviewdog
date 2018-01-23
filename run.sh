#!/bin/sh

THRESHOLD_WARN=${WERCKER_REVIEWDOG_THRESHOLD_WARN-5}
THRESHOLD_FAIL=${WERCKER_REVIEWDOG_THRESHOLD_FAIL-10}

if [ -n "$WERCKER_REVIEWDOG_EXCLUDE" ]; then
  LINTLINES=$(go list ./... | xargs -L1 "$WERCKER_STEP_ROOT"/golint | grep -vE "$WERCKER_REVIEWDOG_EXCLUDE" | "$WERCKER_STEP_ROOT"/reviewdog -f=golint -diff="git diff remotes/origin/master" | tee lint_results.txt | wc -l | tr -d " ")
else
  LINTLINES=$(go list ./... | xargs -L1 "$WERCKER_STEP_ROOT"/golint | "$WERCKER_STEP_ROOT"/reviewdog -f=golint -diff="git diff remotes/origin/master" | tee lint_results.txt | wc -l | tr -d " ")
fi

cat lint_results.txt
if [ "$LINTLINES" -ge "${THRESHOLD_FAIL}" ]; then echo "Time to tidy up: $LINTLINES lint warnings." > "$WERCKER_REPORT_MESSAGE_FILE"; fail "Time to tidy up."; fi
if [ "$LINTLINES" -ge "${THRESHOLD_WARN}" ]; then echo "You should be tidying soon: $LINTLINES lint warnings." > "$WERCKER_REPORT_MESSAGE_FILE"; warn "You should be tidying soon."; fi
if [ "$LINTLINES" -gt 0 ]; then echo "You are fairly tidy: $LINTLINES lint warnings." > "$WERCKER_REPORT_MESSAGE_FILE"; fi


if [ -f .git/FETCH_HEAD ]; then

export CI_PULL_REQUEST=$(awk -F/ '{print $3}' .git/FETCH_HEAD)
export CI_REPO_OWNER=${WERCKER_GIT_OWNER}
export CI_REPO_NAME=${WERCKER_GIT_REPOSITORY}
export CI_COMMIT=${WERCKER_GIT_COMMIT}
export REVIEWDOG_GITHUB_API_TOKEN=${WERCKER_REVIEWDOG_GITHUB_API_TOKEN}
go list ./... | xargs -L1 "$WERCKER_STEP_ROOT"/golint | "$WERCKER_STEP_ROOT"/reviewdog -f=golint -ci=common

fi
