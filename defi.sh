#!/bin/bash

# Separateur de liste est le retour a la ligne
IFS=$'\n'

# Parcourir les fichiers
for fichier in $(ls -a --file-type | grep -v "/" | grep -v "@")
do

	# Recupere les 5 premiers caracteres de la premiere ligne du fichier
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
			
			# Si contient autre chose que caracteres de controle, espace, tabulation et les espaces insécables ou autre blanc horizontaux
			# Retire les caractères de control [:cntrl:] en les transformants en espace le temps du test de la ligne
			# Retire les blancs [:blank:] en les transformants en espace le temps du test de la ligne
			contient=$(echo $ligne | tr [:cntrl:] " " | tr [:blank:] " " | grep -e [^" "$'\xe2\x80\xaf'$'\xc2\xa0'])
			if [[ $contient != "" ]]
			then
			
				# La ligne n est pas vide
				vide=false
				
			fi
			
			# Forme de la ligne
			FORME='^[on][\:][0-9]{3}[\:][a-z]+[\:][0-9]+[\:][0-9]+$'
			
			# Si la ligne 2 ou sup et ligne est de la bonne forme
			if [ $numeroLigne -ge 2 ] && [[ $ligne =~ $FORME ]]
			then
				
				# Ne pas afficher
				afficher=$afficher
				
			else
			# Sinon
				
				# Si num ligne >= 2 et non vide 
				if [ $numeroLigne -ge 2 ] && [ $vide = false ]
				then
					
					# Ne pas afficher
					afficher=false
					
				fi
				
			fi
			
			let numeroLigne=numeroLigne+1
			
		done
		
		if [ $afficher = true ]
		then
				
				# Afficher le nom du fichier en minuscule
				echo "`echo $fichier | tr '[:upper:]' '[:lower:]'`:"
				
				# Parcourir les lignes du fichier pour vérifier sa structure
				for ligne in $(cat "$fichier" | cut -d '#' -f 1)
				do
				
					# On suppose que la ligne est vide de base
					vide=true
					
					# Si contient autre chose que caracteres de controle, espace, tabulation et les espaces insécables ou autre blanc horizontaux
					# Retire les caractères de control [:cntrl:] en les transformants en espace le temps du test de la ligne
					# Retire les blancs [:blank:] en les transformants en espace le temps du test de la ligne
					contient=$(echo $ligne | tr [:cntrl:] " " | tr [:blank:] " " | grep -e [^" "$'\xe2\x80\xaf'$'\xc2\xa0'])
					if [[ $contient != "" ]]
					then
					
						vide=false
						
					fi
					
					# Si la ligne n est pas vide
					if [ $vide = false ]
					then
						
						echo "$ligne"
						
						# Définition des types de lignes
						# OLINES lignes commençant par o
						# NLINES lignes commençant par n
						OLINES='^[o][\:][0-9]{3}[\:][a-z]+[\:][0-9]+[\:][0-9]+$'
						NLINES='^[n][\:][0-9]{3}[\:][a-z]+[\:][0-9]+[\:][0-9]+$'
						
						if [[ $ligne =~ $OLINES ]]
						then
							
							# Envoyer dans o_lines
							echo $ligne >> o_lines
							
						fi
						
						if [[ $ligne =~ $NLINES ]]
						then
							
							# Envoyer dans n_lines
							echo $ligne >> n_lines
							
						fi
						
					fi
					
				done
				
		fi
		
	fi

done
