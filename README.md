# postgresql-backup-s3

If you want to take a regular full backup of your PostgreSQL database in your Kubernetes cluster - here is a container and an example cronjob spec.
It simply runs `pg_dumpall` and then `aws s3 cp` - you will need to provide the arguments for those commands to work (see below).

* [Example cronjob and secret](./kubernetes/)
* [Image on Docker hub](https://hub.docker.com/r/sverrirab/postgresql-backup-s3)

## Configuration

### Container specific

| Variable | Required? | Description |
| -------- | --------- | ----------- |
| DEST_S3_BUCKET | YES | S3 bucket name |
| DEST_S3_FOLDER | | S3 folder name |
| DUMPALL_EXTRA_ARGS | | Additional args (e.g. --schema-only for testing configuration) |

### PostgresSQL specific

| Variable | Required? | Description |
| -------- | --------- | ----------- |
| PGUSER | YES | Database user with full access (typically postgres) |
| PGPASSWORD | YES | Database user password|
| PGHOST | YES | Host (e.g. db.namespace.svc.cluster.local |

For more information see: [PostgreSQL env vars](https://www.postgresql.org/docs/13/libpq-envars.html)

### AWS specific

If your machine is running on AWS with permissions provided by a role this is not required.

| Variable | Required? | Description |
| -------- | --------- | ----------- |
| AWS_ACCESS_KEY_ID | | Access key ID |
| AWS_SECRET_ACCESS_KEY | | Secret Access key |

For more information see: [AWS CLI env vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

## License

Very permissive [MIT License](./LICENSE)

## More information

* [PostgresSQL](https://www.postgresql.org/)
* [Kubernetes](https://kubernetes.io/)
