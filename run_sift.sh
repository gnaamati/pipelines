species=malus_domestica_golden
species=glycine_max
species=phaseolus_vulgaris

SIFT_DIR=/nfs/production/panda/ensembl/variation/data/sift5.2.2/sanger_sift/sift5.2.2
tmpdir=/tmp
NCBI=/nfs/panda/ensemblgenomes/external/ncbi-blast-2+/bin

export PATH=${ENSEMBL_ROOT_DIR}/ensembl-hive/scripts:${PATH}
#export PATH=/nfs/software/ensembl/RHEL7/linuxbrew/bin/:${PATH}

#OUTPUT_DIR=/nfs/nobackup/ensemblgenomes/gnaamati/sift_pipeline/data/malus_domestica_golden
OUTPUT_DIR=/hps/nobackup/flicek/ensembl/plants/${USER}/sift_pipeline/data/common_bean
mkdir -p $OUTPUT_DIR

#ROOT_DIR=/nfs/production/panda/ensemblgenomes/development/gnaamati/apis/master_api
ROOT_DIR=${ENSEMBL_ROOT_DIR}

## Moving on
#registry=/homes/gnaamati/registries/prod3_tgac_var.reg
registry=/homes/gnaamati/registries/plants1.reg

##Hive server
hive_server=mysql-ens-plants-prod-1

PERL5LIB=$ENSEMBL_ROOT_DIR/ensembl-variation/scripts/import:$PERL5LIB
export PATH=$ENSEMBL_ROOT_DIR/ensembl-variation/scripts/import:${PATH}

echo \ #eval $($hive_server --details env_HIVE_)
echo \
init_pipeline.pl \
Bio::EnsEMBL::Variation::Pipeline::ProteinFunction::ProteinFunction_conf \
-species $species \
-pipeline_dir ${OUTPUT_DIR} -ensembl_registry ${registry} \
-include_lrg 0 \
-fasta_file ${OUTPUT_DIR}/${species}.pep \
--pipeline_db -host=mysql-ens-plants-prod-1 --pipeline_db -port=4243 --pipeline_db -user=xxxx --pipeline_db -pass=xxxx \
-sift_dir $SIFT_DIR -sift_working ${OUTPUT_DIR}/sift/ \
-blastdb /nfs/production/panda/ensembl/variation/data/sift5.2.2/uniref90/uniref90.fasta \
-ncbi_dir $NCBI \
-hive_root_dir ${ROOT_DIR}/ensembl-hive/ \
-sift_run_type 1 \
-ensembl_release 104 \
-assembly v2.1 \
-hive_force_init 1 \
 | sed -e 's/\s\+/\n/g' | awk 'NR%2{printf "%s\t",$0;next;}1'

#-blastdb /nfs/panda/ensemblgenomes/external/data/uniref90/uniref90.fasta \

#-pipeline_dir '/nfs/nobackup/ensemblgenomes/egcomp2/var/ta' \

hive_db=${USER}_${pipeline_name}
url=$($hive_server --details url)$hive_db

beekeeper.pl -url $url -sync
beekeeper.pl -url $url -reg_conf $registry -loop

## Or perhaps...
runWorker.pl -url $url -reg_conf $registry
beekeeper.pl -url $url -reg_conf $registry -run
standaloneJob.pl -url $url -reg_conf $registry -run



##Comments
I played with this files:
git checkout modules/Bio/EnsEMBL/Variation/Pipeline/ProteinFunction/BaseProteinFunction.pm
git checkout modules/Bio/EnsEMBL/Variation/Pipeline/ProteinFunction/InitJobs.pm
git checkout modules/Bio/EnsEMBL/Variation/Pipeline/ProteinFunction/ProteinFunction_conf.pm
git checkout modules/Bio/EnsEMBL/Variation/Pipeline/TranscriptFileAdaptor.pm







##For the core stats
#init_pipeline.pl Bio::EnsEMBL::EGPipeline::PipeConfig::CoreStatistics_conf \
    #$($hive_server details script) \
    #-registry $registry \
    #${species_cmd} \
    #-pipeline_name ${pipeline_name} \
    #-hive_force_init 1

##For the ncRNA
#init_pipeline.pl Bio::EnsEMBL::EGPipeline::PipeConfig::RNAFeatures_conf \
 #$($hive_server details script) -registry $registry \
 #-species brassica_rapa -pipeline_name test3 -pipeline_dir /nfs/nobackup/ensemblgenomes/$USER



