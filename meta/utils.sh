#!/usr/bin/env bash

function join_by {
    local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; 
}

