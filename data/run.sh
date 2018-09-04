#!/bin/bash
tippecanoe --no-tile-compression --layer="brewdog" --minimum-zoom=0 --maximum-zoom=14 --base-zoom=0 -e "brewdog" "brewdog.geojson"
cp config.json.brewdog ./brewdog/config.json

