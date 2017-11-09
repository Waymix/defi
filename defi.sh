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
		
			# On suppose que la ligne est vide
			vide=true
			
			# Longueur de la ligne en caracteres
			longueur=$(expr length $ligne)
			
			# Position du caractere initialiser a 1
			pos=1
			
			# Parcourir la ligne caractere par caractere
			while [ $pos -le $longueur ]
			do
			
				# On recupere le caractere
				char=$(expr substr $ligne $pos 1)
				# On recupere la valeur hexadecimal du caractere
				DebutHex=$(echo $char | xxd | cut -c 11 )
				
				let posSuivant=pos+1
				
				if [ $DebutHex = "c" ] || [ $DebutHex = "d" ]
				then
					
					char=$(expr substr $ligne $pos 2)
					let posSuivant=pos+2
					
				fi
				
				if [ $DebutHex = "e" ]
				then
					
					char=$(expr substr $ligne $pos 3)
					let posSuivant=pos+3
					
				fi
				
				if [ $DebutHex = "f" ]
				then
					
					char=$(expr substr $ligne $pos 4)
					let posSuivant=pos+4
					
				fi
				
				hex=$(echo $char | xxd)
				
				# Si le caractere est different de espace ou de tab ou espace insecable
				if [ $hex != "00000000: 200a                                      ." ] && [ $hex != "00000000: 090a                                     .." ] && [ $hex != "00000000: e280 af0a                                ...." ] && [ $hex != "00000000: c2a0 0a                                  ..." ]
				then
				
					vide=false
				
				fi
				
				# On incremente la position de 1
				pos=$posSuivant
				
			done
			
			# Forme de la ligne
			FORME='^[on]:[0-9]{3}[\:][a-z]+[\:][0-9]+[\:][0-9]+$'
			
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
				
					# On suppose que la ligne est vide
					vide=true
					
					# Longueur de la ligne en caracteres
					longueur=$(expr length $ligne)
					
					# Position du caractere initialiser a 1
					pos=1
					
					# Parcourir la ligne caractere par caractere
					while [ $pos -le $longueur ]
					do
					
						# On recupere le caractere
						char=$(expr substr $ligne $pos 1)
						# On recupere la valeur hexadecimal du caractere
						DebutHex=$(echo $char | xxd | cut -c 11 )
						
						let posSuivant=pos+1
						
						if [ $DebutHex = "c" ] || [ $DebutHex = "d" ]
						then
							
							char=$(expr substr $ligne $pos 2)
							let posSuivant=pos+2
							
						fi
						
						if [ $DebutHex = "e" ]
						then
							
							char=$(expr substr $ligne $pos 3)
							let posSuivant=pos+3
							
						fi
						
						if [ $DebutHex = "f" ]
						then
							
							char=$(expr substr $ligne $pos 4)
							let posSuivant=pos+4
							
						fi
						
						hex=$(echo $char | xxd)
						
						# Si le caractere est different de espace ou de tab ou espace insecable
						if [ $hex != "00000000: 200a                                      ." ] && [ $hex != "00000000: 090a                                     .." ] && [ $hex != "00000000: e280 af0a                                ...." ] && [ $hex != "00000000: c2a0 0a                                  ..." ]
						then
						
							vide=false
						
						fi
						
						# On incremente la position de 1
						pos=$posSuivant
						
					done
					
					# Si la ligne n est pas vide
					if [ $vide = false ]
					then
					
						echo "$ligne"
						
					fi
					
				done
				
		fi
		
	fi

done
