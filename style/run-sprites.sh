#!/bin/bash

if ! type "docker" > /dev/null; then
  exit
fi

docker run -it -e FOLDER=_svg -v ${PWD}:/data dolomate/spritezero
mkdir brewdog
mv sprites/sprites* ./brewdog
