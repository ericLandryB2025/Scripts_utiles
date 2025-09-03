# -----------------------------------------------------------------------------
# Script : 
# Auteur : eric badou
# Description : ce script permet d’effectuer les 4 opérations de base
# Paramètres : 
# Date : 
# -----------------------------------------------------------------------------

print("*** calculatrice de base ***")
print("1-Somme")
print("2-Soustraction")
print("3-Multiplication")
print("4-Division")
print("5-Quitter")

choix = input("veuillez choisir l'opération a effectuer :")

if choix == "1":
    valeur1 = float(input("veuillez entrer le premier chiffre: "))
    valeur2 = float(input("veuillez entrer le deuxieme chiffre: "))
    somme = valeur1 + valeur2
    print("Réultat=", somme)

elif choix == "2":
    valeur1 = float(input("veuillez entrer le premier chiffre: "))
    valeur2 = float(input("veuillez entrer le deuxieme chiffre: "))
    soustraction = valeur1 - valeur2
    print("Réultat=", soustraction)

elif choix == "3":
    valeur1 = float(input("veuillez entrer le premier chiffre: "))
    valeur2 = float(input("veuillez entrer le deuxieme chiffre: "))
    multiplication = valeur1 * valeur2
    print("Réultat=", multiplication)

elif choix == "4":
    valeur1 = float(input("veuillez entrer le premier chiffre: "))
    valeur2 = float(input("veuillez entrer le deuxieme chiffre: "))
    if valeur2 == 0:
        print("il n'est pas possible d'effectuer une division par zéro")
        print("résultat = Pas de résultat")
    else:
        division = valeur1 / valeur2
        print("Réultat=", division)

elif choix == "5":
    print("Merci d'avoir utilisé la calculatrice.")

else: 
    print("l'option choisie n'est pas définie")
    print("résultat = Pas de résultat")