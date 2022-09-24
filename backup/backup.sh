#!/bin/bash

s3() {
    s4cmd --endpoint-url=$S3_ENDPOINT s4cmd --access-key=$S3_ACCESS_KEY --secret-key=$S3_SECRET_KEY
}

su git
/usr/local/bin/gitea dump -c ${GITEA_CUSTOM}/conf/app.ini

s4cmd --endpoint-url=$S3_ENDPOINT put gitea*.zip s3://$S3_BUCKET_NAME

CUTOFF=$(date -d "${BACKUP_MAX_AGE}"' days ago' +%s)
mapfile -t ITEMS < <(s3 ls s3://$S3_BUCKET_NAME/*)
unset IFS

for ((i = 0; i < ${#ITEMS[@]}; i++)); do
    ITEM="${ITEMS[$i]}"
    DATE=$(echo "${ITEM}" | cut -d' ' -f1)
    AGE=$(date -d "${DATE}" +%s)
    FILE=$(echo "${ITEM}" | cut -d' ' -f4)
    if (($AGE < $CUTOFF)); then
        s3 del "$FILE"
    fi
done
