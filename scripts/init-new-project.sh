#!/bin/bash

tmpDir=$(mktemp -d)
initTmplDir="$tmpDir/templates/default-project"
scriptsDir="deploy/scripts"
configDir="$scriptsDir/group_vars"
root_suffix='setup_root_password'
user_suffix='setup_user_password'
devConfig='development'
stagingConfig='staging'
productionConfig='production'
allConfigs="$productionConfig $stagingConfig $devConfig"
productionSSLFile="$configDir/production_ssl.yml"
stagingSSLFile="$configDir/staging_ssl.yml"
genSSLScript="$scriptsDir/scripts/generate-ssl-file.sh"
paramList="mongo_parse_password mongo_root_password parse_master_key parse_client_key parse_restapi_key parse_file_key parse_javascript_key parse_dashboard_password"


############################################
if [[  "$(dirname $0)" != *scripts ]]
then
  echo "[ERROR] You should run this script from repo root"
  echo "[ERROR] Example: ./scripts/$(basename $0)"
  exit 1
fi

echo "[INFO] Get current ansible repo URL: "
ansibleRepoUrl=$(git config --get remote.origin.url)
echo $ansibleRepoUrl

echo
echo "[INFO] Create default project structure from template"
# echo $tmpDir
mv * .[^.]* $tmpDir
cp -r $initTmplDir/* .

mv $tmpDir $scriptsDir
rm -rf $tmpDir

echo
echo "[INFO] Git init a new project with submodule"
git init
git submodule add $ansibleRepoUrl $scriptsDir

vaultFile=$(mktemp)


############################################

function getToken {
  if [ $# -eq 1 ]
  then
    openssl rand -base64 $1
  else
    openssl rand -base64 21
  fi
}

#################################

function genVault {

  config=$1
  cat /dev/null > "$configDir/${config}_enc.yml"

  echo
  echo "--------- $config ---------"
  echo
  echo -n "[INFO] New vault password for $config: "
  getToken | tee "${vaultFile}-$config"

  echo
  echo "[INFO] Generating $configDir/${config}_enc.yml"

  echo "${root_suffix}: $(getToken)" | tee -a "$configDir/${config}_enc.yml"
  echo "${user_suffix}: $(getToken)" | tee -a "$configDir/${config}_enc.yml"

  echo
  echo -n "[INFO] Creating encrypted file... "
  ansible-vault encrypt "$configDir/${config}_enc.yml" --vault-password-file="${vaultFile}-$config"

  echo "-----------------------------"
}

#####################################

function insertData {
  echo "$1: $2" >> "$3"
}


echo
echo '[INFO] Generate passwords...'
for item in $paramList
do
  insertData "$item" $(getToken) "$configDir/$stagingConfig.yml"
  insertData "$item" $(getToken) "$configDir/$productionConfig.yml"
done

# generate staging configs
echo
genVault "$stagingConfig"

echo -n "[INFO] Do you have prepared certificate for staging? [n]/y:  "
read ans
if [ "$ans" == "y" ]
then
  bash "$genSSLScript" 000 "$stagingSSLFile" "$vaultFile-$stagingConfig"
fi

# generate prod configs
echo
genVault "$productionConfig"

echo -n "[INFO] Do you have prepared certificate for prod? [n]/y:  "
read ans
if [ "$ans" == "y" ]
then
  bash "$genSSLScript" 000 "$productionSSLFile" "$vaultFile-$productionConfig"
fi
