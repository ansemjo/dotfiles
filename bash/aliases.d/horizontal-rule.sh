#!/usr/bin/env bash
hr() { printf "%$(stty size | cut -d' ' -f2)s\n" | tr '  ' "=$1"; }
