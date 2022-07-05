#!/usr/bin/env bash

echo "y" | terragrunt run-all apply || exit 1
