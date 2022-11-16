#!/bin/sh

systemctl stop nxcprocessing.service
systemctl stop nxcserver.service

echo "
DECIPHER=https\://decipher.sanger.ac.uk/search?q=grch37:*
DECIPHER_BROWSER=https\://www.deciphergenomics.org/browser#q/grch37:*\:*\-*
" >> "./BioDiscovery/NxClinical Server/storage/resources/Organisms/Human/NCBI Build 37/regionbases.txt"

systemctl start nxcprocessing.service
systemctl start nxcserver.service
