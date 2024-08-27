# Cloud Build Job for Importing Data into Google Cloud SQL

This Cloud Build job automates the process of importing data into a Google Cloud SQL instance and executing a DDL script afterward. The job creates a temporary Google Cloud Storage bucket for the import process and deletes the bucket after the import is complete.

## Overview

The Cloud Build job performs the following steps:

1. Creates a temporary Google Cloud Storage bucket with a specified prefix.
2. Copies the SQL file to the temporary bucket.
3. Grants the necessary permissions to the SQL instance's service account.
4. Drop the DB before import.
5. Imports the SQL file into the specified Cloud SQL instance.
6. Executes a DDL script to configure database objects and permissions.
7. Deletes the temporary bucket.
