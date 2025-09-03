# -----------------------------------------------------------------------------
# Script : 
# Auteur : eric badou
# Description : ce script permet davoir des informations du systeme 
# Paramètres : 
# Date : 
# -----------------------------------------------------------------------------

import os
import time
import getpass

# Affiche la date et l'heure actuelles
print(f"Date et heure actuelles : {time.ctime()}")
#Afficher le nom de l'utilisateur
print(f"Nom de l'utilisateur : {getpass.getuser()}")

#Afficher le chemin et nom du dossier courant.
DossierCourant= os.getcwd()
print(f"Dossier courant : {DossierCourant}")

#Lister les éléments qui se trouvent dans le dossier courant
print("Éléments du dossier courant :")
element = os.listdir(DossierCourant)
print(element)

#Vérifier si l’élément nommé « dossier1 » existe dans le dossier courant. 
# S’il existe, vérifier qu’il s’agit d’un dossier.
dossier1= os.path.join(DossierCourant, "dossier1")
if os.path.exists(dossier1):
    print("l'element 'dossier1' existe.")
    if os.path.isdir(dossier1):
        print("l'element 'dossier1' est un dossier.")
else:
    print("l'element 'dossier1' n'existe pas.")

#Créer, dans le dossier courant, un nouveau dossier nommé nouveauDossier. 
# Si le dossier existe déjà, ne pas essayer de le créer à nouveau.
nouveauDossier = os.path.join(DossierCourant, "nouveauDossier")
if not os.path.exists(nouveauDossier):
    os.makedirs(nouveauDossier)
    print("le dossier 'nouveauDossier' a été créé.")
else:
    print("le dossier 'nouveauDossier' existe déjà.")

#Éliminer le dossier créé à l’étape précédente. Si le dossier n’existe pas, 
# ne pas essayer de l’éliminer.

if os.path.exists(nouveauDossier):
    os.rmdir(nouveauDossier)
    print("le dossier 'nouveauDossier' a été supprimé.")
else:
    print("le dossier 'nouveauDossier' n'existe pas.")

#Changer de dossier : aller vers le dossier nommé dossier1
print("changement de dossier")

if os.path.exists(dossier1) and os.path.isdir(dossier1):
    os.chdir(dossier1)
    print(f"Dossier courant : {os.getcwd()}")
else:
    print("le 'dossier1' n'existe pas")

#Changer de dossier : revenir vers le dossier parent de dossier1
print("changement de dossier")

os.chdir(DossierCourant)
print(f"Dossier courant : {os.getcwd()}")

#Créer un nouveau fichier nommé « monFichier.txt » ayant le contenu « Bonjour [votre nom] ! ».
#  Si le fichier existe déjà, ne pas essayer de le créer à nouveau.

fichier = os.path.join(DossierCourant, "monFichier.txt")
if not os.path.exists(fichier):
    with open(fichier, "w") as f:
        f.write("Bonjour eric !")
    print("le fichier 'monFichier.txt'  a été créé.")
else:
    print("le fichier 'monFichier.txt'existe déjà.")

#Renommer le fichier créé vers monFichier2.txt. Si le fichier source n’existe pas, ne pas essayer de le renommer.
#  Si le fichier de destination existe déjà, on doit le supprimer préalablement.

fichier2= os.path.join(DossierCourant, "monFichier2.txt")
if os.path.exists(fichier):
    if os.path.exists(fichier2):
        os.remove(fichier2)
    os.rename(fichier, fichier2)
    print("le fichier 'monFichier.txt a été renommé vers 'monFichier2.txt' ")
else:
    print("le fichier 'monFichier.txt  n'existe pas.")


#Obtenir la dernière date_heure d’accès au fichier monFichier2.txt

last_access_time = os.path.getatime(fichier2)
print(f"le dernier moment dacces au fichier 'monFichier2.txt' est : {time.ctime(last_access_time)}")

#Obtenir la taille du fichier monFichier2.txt
file_size = os.path.getsize(fichier2)
print(f"le fichier 'monFichier2.txt' a une taille de : {file_size} octets")

#Obtenir le nom de l’utilisateur courant du système d’exploitation
nomUtilisateur = os.getlogin()
print(f"l'utilisateur actuel est : {nomUtilisateur}")

#Obtenir le type du système d’exploration. Pour les systèmes Windows le nom affiché est « nt ». 
# Pour les systèmes Linux le nom affiché sera « posix »

systeme = os.name
print(f"Type du système d'exploitation : {systeme}")