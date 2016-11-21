#!/bin/bash
USERNAME=$1
BRANCH='develop'
TODAY="$(date --utc -d 'today 00:00')"

for REPO in `travis repos -a -o $USERNAME --no-interactive`; do
    echo "Processing $REPO:"
    HISTORY="$(travis history -r $REPO -b develop --limit 1 --no-interactive -d)"
    if grep -q 'not yet' <<<$HISTORY; then
        echo "Skipping: Currently building"
        echo ""
        continue
    fi;
    DATE="$(echo $HISTORY | awk '{print $1}' | xargs date --utc --date)"
    if [[ $DATE == $TODAY ]]; then
        echo "Skipping: Build today"
        echo ""
        continue
    fi;
    travis restart -r $REPO $HISTORY
    echo ""
done
