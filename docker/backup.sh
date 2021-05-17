#!/bin/bash

set -eo pipefail

declare -a required=(
  "PGUSER"
  "PGHOST"
  "PGPASSWORD"
  "DEST_S3_BUCKET"
)

echo_usage_and_exit=0

for variable in "${required[@]}"; do
  if [[ -z "${!variable}" ]]; then
    echo "Please set $variable and run again"
    echo_usage_and_exit=1
  fi
done

# Optional variables
dest_s3_folder="${DEST_S3_FOLDER}"
dumpall_extra_args="${DUMPALL_EXTRA_ARGS}"

set -u

echo "Checking AWS credentials"
if ! aws s3api list-buckets --query Owner.ID --output text &>/dev/null; then
  echo "You need to provide working AWS credentials (e.g. AWS_ACCESS_KEY_ID...)"
  echo_usage_and_exit=1
fi

if [ $echo_usage_and_exit -eq 1 ]; then
  echo "Missing required environment variables - cannot continue"
  echo "Optional: DEST_S3_FOLDER DUMPALL_EXTRA_ARGS"
  echo "For Postgres see: https://www.postgresql.org/docs/13/libpq-envars.html"
  echo "For AWS see: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html"
  exit 3
fi

timestamp=$(date +%Y%m%d-%H%M)
filename="full-backup-${timestamp}.sql.gz"
dest_s3=$(echo "${DEST_S3_BUCKET}/${dest_s3_folder}/${filename}" | sed "s#//#/#g")
s3_full_name="s3://${dest_s3}"

echo "Will write to $s3_full_name"

echo "Running pg_dumpall and writing to $filename..."
pg_dumpall $dumpall_extra_args --no-password | gzip >"${filename}"

echo "Copying to $s3_full_name"
aws s3 cp "${filename}" "${s3_full_name}"

echo "Backup done successfully"
