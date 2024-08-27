#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Description: Script to copy an SQL file to Google Cloud Storage and then import 
#              it into a Google Cloud SQL instance. Also executes a DDL script 
#              after the import and cleans up the temporary bucket.
# Author:      Patryk Golabek
# Copyright:   2024 Translucent Computing Inc.
# -----------------------------------------------------------------------------

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Ensure arguments are provided
if [ "$#" -ne 6 ]; then
    log "Error: Missing arguments"
    echo "Usage: $0 <INSTANCE_NAME> <INSTANCE_PROJECT> <INSTANCE_REGION> <BUCKET_PREFIX> <DATABASE_NAME> <USERNAME>"
    exit 1
fi

# Variables
INSTANCE_NAME="$1"
INSTANCE_PROJECT="$2"
INSTANCE_REGION="$3"
BUCKET_PREFIX="$4"
DATABASE_NAME="$5"
USERNAME="$6"
DATABASE_PASS="$DATABASE_PASS"

SQL_FILE="nwnd.sql"
DDL_SCRIPT="add_role.sql"
BUCKET_NAME="${BUCKET_PREFIX}-$(date +%s)"
INSTANCE="${INSTANCE_PROJECT}:${INSTANCE_REGION}:${INSTANCE_NAME}"

# Install sqlcmd and tools
log "Installing sqlcmd and tools"
curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
apt-get update
ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
source ~/.bashrc

# Create temporary bucket if it doesn't exist
log "Creating temporary bucket $BUCKET_NAME"
if gsutil ls -b gs://$BUCKET_NAME &>/dev/null; then
    log "Bucket $BUCKET_NAME already exists"
else
    gsutil mb gs://$BUCKET_NAME || { log "Failed to create temporary bucket"; exit 1; }
fi

# Copy SQL file to GCS
log "Copying \"$SQL_FILE\" to gs://$BUCKET_NAME/sql/$SQL_FILE"
if gsutil ls gs://$BUCKET_NAME/sql/$SQL_FILE &>/dev/null; then
    log "File $SQL_FILE already exists in the bucket"
else
    gsutil cp "$SQL_FILE" gs://$BUCKET_NAME/sql/$SQL_FILE || { log "Failed to copy SQL file to GCS"; exit 1; }
fi

# Get the service account associated with the SQL instance
log "Fetching service account for $INSTANCE_NAME"
SERVICE_ACCOUNT=$(gcloud sql instances describe $INSTANCE_NAME --format="value(serviceAccountEmailAddress)") || { log "Failed to fetch service account"; exit 1; }

# Grant the service account permissions on the bucket
log "Granting permissions to $SERVICE_ACCOUNT on gs://$BUCKET_NAME"
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT:objectAdmin gs://$BUCKET_NAME || { log "Failed to grant permissions"; exit 1; }

# Retrieve the public IP address of the SQL Server instance
INSTANCE_IP=$(gcloud sql instances describe "$INSTANCE_NAME" --format="value(ipAddresses[0].ipAddress)") || { log "Failed to fetch instance IP"; exit 1; }

#  Drop or truncate the database before import
log "Dropping or truncating the database $DATABASE_NAME"
sqlcmd -S tcp:$INSTANCE_IP -U sqlserver -P "$DATABASE_PASS" -Q "DROP DATABASE IF EXISTS [$DATABASE_NAME]; CREATE DATABASE [$DATABASE_NAME];" -C || { log "Failed to drop or create database"; exit 1; }

# Import SQL file to Cloud SQL instance
log "Importing $SQL_FILE to $INSTANCE_NAME"
gcloud sql import sql $INSTANCE_NAME gs://$BUCKET_NAME/sql/$SQL_FILE --database=$DATABASE_NAME || { log "Failed to import SQL file to Cloud SQL"; exit 1; }

# Replace placeholders in the DDL script
log "Replacing placeholders in the DDL script"
sed -i "s/{{DATABASE_NAME}}/$DATABASE_NAME/g" "$DDL_SCRIPT"
sed -i "s/{{USERNAME}}/$USERNAME/g" "$DDL_SCRIPT"

# Execute the DDL script
log "Executing the DDL script"
sqlcmd -S tcp:$INSTANCE_IP -U sqlserver -P "$DATABASE_PASS" -d $DATABASE_NAME -i "$DDL_SCRIPT" -C || { log "Failed to execute DDL script"; exit 1; }

# Clean up temporary bucket
log "Deleting temporary bucket $BUCKET_NAME"
gsutil rm -r gs://$BUCKET_NAME || { log "Failed to delete temporary bucket"; exit 1; }

log "Script completed successfully!"