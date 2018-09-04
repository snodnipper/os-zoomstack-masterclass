#!/bin/bash

OUTPUT=brewdog.geojson

function logo () {
  echo "
                  @@@@@@@         @@@@@@@                  
                 @@@@@@@@@@     @@@@@@@@@@@                                        
         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@    
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @ @@@@@@@@@
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @  @@@@@@@@
 @@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    @  @@@@@@@@
 @@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        @@@@@@@@
 @@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@            @@@@@@@ 
  @@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@     @@     @@@@@@@@ 
  @@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@     @@     @@@@@@@@ 
  @@@@@@@@       @@@@@@@@@@@@@@@@@@@@@            @@@@@@@@  
   @@@@@@@@         @@@@@@@@@@@@@@                @@@@@@@@  
   @@@@@@@@             @@@@@@@@                 @@@@@@@@   
   @@@@@@@@@                                    @@@@@@@@@   
    @@@@@@@@@@@                               @@@@@@@@@@    
     @@@@@@@@@@@                            @@@@@@@@@@@@    
     @@@@@@@@                                 @@@@@@@@@     
      @@@@@                                      @@@@@      
       @@  @@@          @@@@@@@@@@@@          @@@  @@       
        @@@@@       @@@@@@@@@@@@@@@@@@@@       @@@@@       
         @@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@    @@@            
           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           
            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            
              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              
                 @@@@@@@@@@@@@@@@@@@@@@@@@@@                
                  @@@@@@@@@@@@@@@@@@@@@@@@                  
                    @@@@@@@@@@@@@@@@@@@@
                    
                    
                   Where is your Brewdog? 
                    
                    "
}

function printStart () {
  echo "{
  \"type\": \"FeatureCollection\",
  \"features\": [" > $OUTPUT
}

function printFeature () {
  echo "{
  \"type\": \"Feature\",
  \"properties\": {
    \"name\": \"$1\"
  },
  \"geometry\": {
    \"type\": \"Point\",
    \"coordinates\": [
      $2
    ]
  }
}" $3 >> $OUTPUT
}

function printEnd () {
  echo "  ]
  }" >> $OUTPUT
}

function printSeparator () {
  echo "," >> $OUTPUT
}

logo
printStart

BARS=$(curl -s https://www.brewdog.com/bars/uk/ | sed -e '/^.*title.*href="\/bars\/uk\/.*/!d' -e 's/.*href="\/bars\/uk\/\(.*\)">/\1/')

first=true
echo "$BARS" | while read DOG; do
    echo Processing $DOG
    if [ "$first" = true ] ; then
      first=false
    else 
      printSeparator
    fi
    HTML=$(curl -s https://www.brewdog.com/bars/uk/$DOG)
    LOCATION=$(echo "$HTML" | sed -e '/^.*<div id="map" data-lat/!d' -e 's/.*data-lat="\(.*\)" data-lng="\(.*\)">.*/\2, \1/')
    TITLE=$(echo "$HTML" | sed -e '/^<h2>Brewdog .*<\/h2>$/!d' -e 's/<h2>Brewdog \(.*\)<\/h2>/\1/')
    printFeature "$TITLE" "$LOCATION" "$SEPARATOR"
done

printEnd
