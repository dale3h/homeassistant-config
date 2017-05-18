#!/bin/bash

for number in "$@"; do
  echo "I am dying, please plug in Stuart's iPhone so it doesn't die!" | /usr/bin/gammu sendsms TEXT $number
done
