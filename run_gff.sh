#https://www.ebi.ac.uk/seqdb/confluence/display/EnsGen/Load+GFF3+Pipeline
pipeline_name=gff_loader_barnyard

species=echinochloa_crusgalli

pipeline_dir=/hps/nobackup/flicek/ensembl/plants/${USER}//gff_loader/barnyard
mkdir -p $pipeline_dir

path=/nfs/production/flicek/ensembl/plants/external_data/echinochloa_crusgalli/gff

gff_file=$path/EC.gff
gene_source=ziu

## Moving on
registry=/hps/software/users/ensembl/ensw/registries/ensembl/pl1-w.pm


hive_server=mysql-ens-plants-prod-1-ensrw

##Run the pipeline
echo init_pipeline.pl Bio::EnsEMBL::Pipeline::PipeConfig::LoadGFF3_conf \
  $($hive_server details script) \
  -registry $registry \
  -pipeline_dir $pipeline_dir \
  -species $species \
  -gff3_file $gff_file \
  -fix_models 0 \
  -gene_source $gene_source \
  -production_db mysql://ensro@mysql-ens-meta-prod-1:4483/ensembl_production \
  -db_type core \
  -delete_existing 0 \
  -hive_force_init 1 \
  | sed -e 's/\s\+/\n/g' | awk 'NR%2{printf "%s\t",$0;next;}1'
  
  #-db_type core \

hive_db=${USER}_${pipeline_name}
url=$($hive_server --details url)$hive_db

beekeeper.pl -url $url -sync
beekeeper.pl -url $url -reg_conf $registry -loop

#perl# Or perhaps...
runWorker.pl -url $url -reg_conf $registry
beekeeper.pl -url $url -reg_conf $registry -run
standaloneJob.pl -url $url -reg_conf $registry -run

run_the_xref_pipelines.sh:

oipeline_name=dna_features_arabidopsis

url="${url};reconnect_when_lost=1"
run_the_xref_pipelines.sh:url="${url};reconnect_when_lost=1"

