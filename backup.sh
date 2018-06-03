# Backup script  
# Testé avec Ubuntu 16.04.4 LTS
# Modifier les variables en début de script
# Nécessite une connexion ssh sans password avec les serveurs de sauvegarde
# 	cd ~
# 	ssh-keygen # Do not set passphrase
# 	ssh-copy-id -i ~/.ssh/id_rsa.pub xxx.xxx.xx.xxx
# Pour créer un cron
# 	export VISUAL=vi
# 	crontab -e
# 	0 3 * * * bash /toto/sdb/backup.sh

# --- Configuration
to_save=( 
	# Ex: "/toto/tata", "/home/rhum/.screen*"	
)
backup_host="56.15.xx.xxx"
backup_lgn="jonhDoe"
backup_dir="/toto/backup"
receiver_mail="toto@mail.com"
# --- 

# Gestion des erreurs
the_host=`hostname -f`
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "\"${last_command}\" command filed with exit code $?."  | mail -s "${the_host} - Backup ERROR" -a From:tot\<backup@vps540666.ovh.net\> ${receiver_mail}' EXIT # echo an error message before exiting

for l in "${to_save[@]}"
do
	rsync -v -a $l $backup_lgn@$backup_host:$backup_dir
done