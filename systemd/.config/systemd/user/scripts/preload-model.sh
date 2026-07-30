#!/bin/sh
while ! curl -s http://localhost:11434/api/tags > /dev/null; do
  sleep 1
done

curl -s -X POST http://localhost:11434/api/generate -d '{"model":"'"$1"'"}' > /dev/null
