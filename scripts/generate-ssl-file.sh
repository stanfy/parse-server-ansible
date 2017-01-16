#!/bin/bash

plainSSLFile='prepared.yml'
sslPath="$1"
dstFile="$2"
vaultFile="$3"

if [ $# -lt 2 ]
then
	echo "Usage: ./$0  pathToDirWithSSL outputFile"
    exit 1
fi

function getPerm {
	stat -f  "u=%SHp,g=%SMp,o=%SLp" "$1"| sed 's/-//g'
}

if [ "$sslPath" == "000" ]
then
	while true
	do
		echo
		echo "[INFO] Enter full path to dir with ssl files: "
		read sslPath
		echo -n "[INFO] Is it right: $sslPath [n]/y: "
		read ans
		if [ "$ans" == "y" ]
		then
			if [ ! -d "$sslPath" ]
			then
				echo "[ERROR] $sslPath - not found"
			else
				break
			fi
		fi
	done
elif [ ! -d "$sslPath" ]
then
	echo "[ERROR] $sslPath - not found"
	exit 1
fi


pushd "$sslPath" > /dev/null
	echo "[INFO] Create $sslPath/$plainSSLFile "
	echo "secret_files:" > "$plainSSLFile"

	ls | grep -v "$plainSSLFile" | while read fileName
	do
		echo "$fileName"
		data=$(cat "$fileName"| sed "s/^/\ \ \ \ \ \ /" )
		currentPerm=$(getPerm "$fileName")
cat <<EOF >> "$plainSSLFile"
  $fileName:
    permissions: $currentPerm
    content: |
$data
EOF
	done
popd > /dev/null


if [ $# -eq 3 ]
then
	ansible-vault encrypt "$sslPath/$plainSSLFile" --vault-password-file="$vaultFile" && \
	mv "$sslPath/$plainSSLFile" "$dstFile" && \
	echo "[INFO] Moved to $dstFile"
else
	ansible-vault encrypt "$sslPath/$plainSSLFile" && \
	mv "$sslPath/$plainSSLFile" "$dstFile" && \
	echo "[INFO] Moved to $dstFile"
fi
