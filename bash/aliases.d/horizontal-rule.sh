#!/bin/sh
function hr {
    printf "%$(stty size | cut -d' ' -f2)s\n" | tr '  ' "=$1"
}
