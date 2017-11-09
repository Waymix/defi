#!/bin/bash

# Separateur de liste est le retour a la ligne
IFS=$'\n'

# Parcourir les fichiers
for fichier in $(ls -a --file-type | grep -v "/" | grep -v "@")
do

	debutFichier=$(head -n 1 "$fichier" | cut -c -5)
	
	# Si le debut du fichier est data:
	if [ "$debutFichier" = "data:" ]
	then
		
		# Numero de ligne initialise a 1
		numeroLigne=1
		
		# On suppose que le fichier est correct de base
		afficher=true
		
		# Parcourir les lignes du fichier pour vérifier sa structure
		for ligne in $(cat "$fichier" | cut -d '#' -f 1)
		do
		
			# On suppose que la ligne est vide de base
			vide=true
			
			# Si contient autre chose que espace, tabulation et les espaces insécables
			# ancien à la fin du grep entre crochets $'\x01'$'\x02'
			# Maintenant retire caractères de control [:cntrl:] en les transformants en espace insécable le temps du test de la ligne
			# Maintenant retire les blancs [:blank:] en les transformants en espace le temps du test de la ligne
			contient=$(echo $ligne | tr [:cntrl:] " " | tr [:blank:] " " | grep -e [^" ""	"" "" "])
			if [[ $contient != "" ]]
			then
			
				vide=false
				
			fi
			
			# Forme de la ligne
			FORME='^[on]:[0-9]{3}[\:][a-z]+[\:][0-9]+[\:][0-9]+[" ""	"" "" "]*$'
			
			# Si le ligne 2 ou sup et ligne de la forme
			if [ $numeroLigne -ge 2 ] && [[ $ligne =~ $FORME ]]
			then
				
				afficher=$afficher
				#echo "bien formé"
				
			else
			# Sinon
				
				# Si num ligne >= 2 et non vide 
				if [ $numeroLigne -ge 2 ] && [ $vide = false ]
				then
					
					afficher=false
					#echo "mal formé"
					
				fi
				
			fi
			
			let numeroLigne=numeroLigne+1
			
		done
		
		if [ $afficher = true ]
		then
				
				echo "`echo $fichier | tr '[:upper:]' '[:lower:]'`:"
				
				# Parcourir les lignes du fichier pour vérifier sa structure
				for ligne in $(cat "$fichier" | cut -d '#' -f 1)
				do
				
					# On suppose que la ligne est vide de base
					vide=true
					
					# Si contient autre chose que espace, tabulation et les espaces insécables
					# ancien à la fin du grep entre crochets $'\x01'$'\x02'
					# Maintenant retire caractères de control [:cntrl:] en les transformants en espace insécable le temps du test de la ligne
					# Maintenant retire les blancs [:blank:] en les transformants en espace le temps du test de la ligne
					contient=$(echo $ligne | tr [:cntrl:] " " | tr [:blank:] " " | grep -e [^" ""	"" "" "])
					if [[ $contient != "" ]]
					then
					
						vide=false
						
					fi
					
					# Si la ligne n est pas vide
					if [ $vide = false ]
					then
					
						echo "$ligne"
						
					fi
					
				done
				
		fi
		
	fi

done
