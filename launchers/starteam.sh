#!/bin/bash

pgrep steam || sh -c 'steam' & disown

exit 0