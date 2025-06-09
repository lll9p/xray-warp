#! /bin/bash
echo $(uname -m | sed 's/x86_64/64/; s/aarch64/arm64-v8a/')