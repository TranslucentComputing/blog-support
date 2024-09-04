/**
 * Required providers for Kubectl module
 *
 * Copyright 2024 Translucent Computing Inc.
 */


terraform {
  required_version = ">= 1.6"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.2"
    }
  }
}
