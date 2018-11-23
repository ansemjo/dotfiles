#!/bin/sh
hr() { printf "%$(stty size | cut -d' ' -f2)s\n" | tr '  ' "=$1"; }
