#!/bin/bash

# http://www.norgeskart.no/?&_ga=2.91831390.573695636.1498461880-705917044.1470919579#!?zoom=9&lon=904099.61&lat=7910878.25&project=dekning&layers=1008

scale=1354
COL_START=$((2504 - 10))
ROW_START=$((839 - 8))

tilenr=0
imax=20
jmax=20
all_tiles=""
workdir="images3"

mkdir -p $workdir

for (( i = 0; i < ${imax}; i++ )); do
  for (( j = 0; j < ${jmax}; j++ )); do
    tilenr=$((tilenr + 1))
    tilename="tile_${tilenr}.png"
    COL=$((COL_START + j))
    ROW=$((ROW_START + i))

    server="gatekeeper1.geonorge.no"
    key="98112C34934C066CB7DF8EFB4D6122D40FC759A18E1D6DF38DF829231A08590AA9678AB96D6E1FC113B57E5BAA3F284CBC8633929A70B5118D018F0853CD0DA1"
    curl -XGET "http://${server}/BaatGatekeeper/gk/gk.cache_wmts?gkt=${key}&layer=sjokartraster&style=default&tilematrixset=EPSG%3A25833&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image%2Fpng&TileMatrix=EPSG%3A25833%3A12&TileCol=${COL}&TileRow=${ROW}" > ${workdir}/${tilename}

    all_tiles="${all_tiles} ${tilename}"
  done
done

cd $workdir
montage $all_tiles -tile ${imax}x${jmax} -border 0 -frame 0 -geometry +0+0 full_image.png
cd ..

