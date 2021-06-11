dnl SPDX-License-Identifier: MIT
dnl
dnl Copyright (c) 2021 Sartura Ltd.
dnl
divert(-1)

dnl Additional m4 macros
define(`setdef',`ifdef(`$1',,`define(`$1', `$2')')')
define(`concatdef',`define(`$1',$1` $2')')

dnl Dynamic variables are empty by default
setdef(`__makeopts__',   `')
setdef(`__emergeopts__', `')
setdef(`__mirrors__',    `')

dnl Experimental feature transforms for the `RUN` instruction
define(`__renv__',       `--mount=type=secret,id=env,target=/run/environment')
define(`__rdistfiles__', `--mount=type=cache,target=/var/cache/distfiles')
define(`__rccache__',    `--mount=type=cache,target=/var/cache/ccache')

divert(0)dnl
