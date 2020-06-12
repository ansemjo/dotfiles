#!/usr/bin/env bash
# try to memorize that pushd and popd are really useful ..
# meanwhile, use 'sd' (switch directory) for a common use case
# of pushd:
# $ sd other/dir  // put current dir on stack and switch to other/dir
# $ sd            // rotate through stack
sd() { pushd "${1-+1}"; }
