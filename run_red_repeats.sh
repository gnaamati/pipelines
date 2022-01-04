cd /nfs/production/flicek/ensembl/plants/repeatdetector

pyenv shell 3.7.9 plant-scripts

species=thinopyrum_elongatum
db=thinopyrum_elongatum_core_53_106_1
#genome_path=/nfs/production/panda/ensemblgenomes/data/Plants/repeatdetector/genomes
genome_path=/nfs/production/flicek/ensembl/plants/repeatdetector    
genome=$species.dna.fasta
hive_server=mysql-ens-plants-prod-1-ensrw

##Get fasta
echo perl $soft/plant_tools/production/misc_scripts/get_toplevel_seq.pl $db $species pl1 none > $genome

##Run Red
echo python plant-scripts/repeats/Red2Ensembl.py \
$genome_path/$genome $species --cor 4 \
$($hive_server details script) \
--db $db --pw writ3rp3 \
| sed -e 's/\s\+/\n/g' | awk 'NR%2{printf "%s\t",$0;next;}1'

##Annotate repeats 
echo python plant-scripts/repeats/AnnotRedRepeats.py \
plant-scripts/files/nrTEplantsJune2020.fna $species --cor 4 \
$($hive_server details script) \
--db $db --pw writ3rp3 \
| sed -e 's/\s\+/\n/g' | awk 'NR%2{printf "%s\t",$0;next;}1'

