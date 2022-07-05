#!/usr/bin/env bash

echo "y" | terragrunt run-all destroy || exit 1
