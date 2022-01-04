registry=/hps/software/users/ensembl/ensw/registries/ensembl/pl1-w.pm
registry2=/hps/software/users/ensembl/ensw/registries/ensembl/pl2-w.pm
hive_server=mysql-ens-plants-prod-1-ensrw
test_registry=/homes/gnaamati/plants.pm

echo init_pipeline.pl Bio::EnsEMBL::Production::Pipeline::PipeConfig::ProductionDBSync_conf \
  $(h1-w details hive) \
  -registry /hps/software/users/ensembl/ensw/registries/ensembl/pl1-w.pm \
  -division plants \
  -group core \
  -pipeline_dir /hps/scratch/flicek/ensembl/$USER/prod_db_sync


  #-history_file /nfs/panda/ensembl/production/datachecks/history/st3.json \
init_pipeline.pl Bio::EnsEMBL::Production::Pipeline::PipeConfig::ProductionDBSync_conf \
  $($hive_server details script) \
  -registry $registry \
  -division fungi \
  -division metazoa \
  -division plants \
  -division protists \
  -group core \
  -group funcgen \
  -group otherfeatures \
  -group variation \
  -backup_dir /hps/nobackup2/production/ensembl/${USER}/prod_db_sync/st3 \
  -history_file /nfs/panda/ensembl/production/datachecks/history/st3.json

##Multi Species Run
echo init_pipeline.pl Bio::EnsEMBL::EGPipeline::PipeConfig::CoreStatistics_conf \
    $($hive_server details script) \
    -registry $registry \
    $species_cmd \
    -pipeline_name $name \
    -hive_force_init 1




hive_db=${USER}_${pipeline_name}
url=$($hive_server --details url)$hive_db

beekeeper.pl -url $url -sync
beekeeper.pl -url $url -reg_conf $registry -loop

## Or perhaps...
runWorker.pl -url $url -reg_conf $registry
beekeeper.pl -url $url -reg_conf $registry -run
standaloneJob.pl -url $url -reg_conf $registry -run

runWorker.pl -url $url -reg_conf $registry -job_id 3 -debug 1 -force 1 ##Run a worker again









##For the ncRNA
#init_pipeline.pl Bio::EnsEMBL::EGPipeline::PipeConfig::RNAFeatures_conf \
 #$($hive_server details script) -registry $registry \
 #-species brassica_rapa -pipeline_name test3 -pipeline_dir /nfs/nobackup/ensemblgenomes/$USER


