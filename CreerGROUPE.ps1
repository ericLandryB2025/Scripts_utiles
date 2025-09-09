# Fonctionnalité A : Script utile Powershell pour création des groupes active directory
# -----------------------------------------------------------------------------
# Script : [creerGroupe.ps1]
# Auteur : [Jane Grace Davis Ngo Massing Soun]
# Description : [CE script permet de créer des groupes AD dont leurs informations se trouvent dans un fichier csv]
# Paramètres : [Fichier, nomgroupe]
# Date : [2025-04-11]
# -----------------------------------------------------------------------------

# Variable globale du domaine
$domaine = "DC=mondomaine,DC=ca"

#Paramètre
#Fonction pour l'affichage du menu 
function afficherMenu {
    Clear-Host
    Write-Host "******** Bienvenue a votre console d'automatisation AD ********" 
    Write-Host "1- Creer groupes"
    Write-Host "2- Creer utilisateurs"
    Write-Host "3- Creer unites d'organisation"
    Write-Host "4- Placer un utilisateur dans des unites d'organisation"
}

#Fonction pour verifier si le groupe existe deja 
function groupeExiste($nomGroupe) {
   $groupe = Get-ADGroup -Filter {Name -eq $nomGroupe}
   return $groupe
}

#Fonction pour créer un nouveau groupe 
function nouveauGroupe($nomGroupe) {
    New-ADGroup -Name $nomGroupe -GroupCategory Security -GroupScope Global
    Write-Host "Le groupe '$nomGroupe' a ete cree." 
}

# Fonction créer le groupe a partir d'un fichier csv
function CreerGroupes {
    $fichierGroupes = ".\groups.csv"

    if (-not $fichierGroupes) {
        Write-Host "Le fichier $fichierGroupes n'existe pas"
        return
    }
   
    $donnees = Import-Csv $fichierGroupes
    foreach ($ligne in $donnees) {
        $nomGroupe = $ligne.nom
        if (groupeExiste $nomGroupe) {
            Write-Host "WARNING: Le groupe '$nomGroupe' existe deja en AD." -ForegroundColor Yellow
        } else {
            nouveauGroupe $nomGroupe
        }
    }
}

#Fonction pour vérifier si l'utilisateur existe
function utilisateurExiste($nomUti) {
    $user = Get-ADUser -Filter {SamAccountName -eq $nomUti}
    return $user
}

#Fonction pour créer les utilisateurs a partir d'un fichier csv
function CreerUtilisateurs($Fichier) {
    $fichierUser = ".\users.csv"

    if (-not $fichierUser) {
        Write-Host "Le fichier $fichierUser n'existe pas"
        return
    }

    $donnees = Import-Csv $fichierUser

    foreach($ligne in $donnees) {
        $nomUti = $ligne.Username
        $mdp = $ligne.Password
        $prenom = $ligne.Prenom
        $nomFamille = $ligne.NomFamille
        $active = $ligne.Active -eq 'oui'
        $nomGroupe = $ligne.Groupe

        if (utilisateurExiste $nomUti) {
            Write-Host "WARNING: L'utilisateur '$nomUti' existe deja en AD." -ForegroundColor Yellow
        } else {
            New-ADUser -Name ($prenom +" "+ $nomFamille) -SamAccountName $nomUti -AccountPassword (ConvertTo-SecureString $mdp -AsPlainText -Force) -GivenName $prenom -Surname $nomFamille -Enabled $active
           
            if (groupeExiste $nomGroupe) {
                Add-ADGroupMember -Identity $nomGroupe -Members $nomUti
                Write-Host "L'utilisateur '$nomUti' a ete cree et ajoute au groupe '$nomGroupe'" 
            } else {
                Write-Host "WARNING: Le groupe '$nomGroupe' n'existe pas en AD." -ForegroundColor Yellow
                Write-Host "L'utililisateur '$nomUti' a ete cree sans l'ajouter a un groupe" 
            } 
        }
    }
}

#Fonction pour créer les unités d'organisation
function CreerOU {
    $fichierOU = ".\ou.csv"

    if (-not $fichierOU) {
        Write-Host "Le fichier $fichierOU n'existe pas"
        return
    }

    $donnees = Import-Csv -Path $fichierOU -Delimiter ';'

    foreach ($ligne in $donnees) {
        $nomOU = $ligne.Nom
        $descriptionOU = $ligne.Description
        $parentOU = $ligne.Parent
        $ouExist= Get-ADOrganizationalUnit -Filter { Name -eq $nomOU }

        if ($ouExist) {
            Write-Host "WARNING: L'element '$((Get-ADOrganizationalUnit -Filter "Name -eq '$($nomOU)'"))' existe deja en AD" -ForegroundColor Yellow
        } else {
            if ($parentOU -eq "Domain") {
                New-ADOrganizationalUnit -name $nomOU -Path $domaine -Description $descriptionOU -ProtectedFromAccidentalDeletion $false
                Write-Host "L'element '$((Get-ADOrganizationalUnit -Filter "Name -eq '$($nomOU)'"))' a ete cree"
            } else {
                New-ADOrganizationalUnit -Name $nomOU -Description $descriptionOU -Path ("OU=" + $parentOU + "," + $domaine)
                Write-Host "L'element '$((Get-ADOrganizationalUnit -Filter "Name -eq '$($nomOU)'"))' a ete cree"
            }
        }
    }
}

# Fonction pour placer un utilisateur dans une OU
function placerUtilisateur {
    $utilisateur = Read-Host "Veuillez entrer le nom de l'utilisateur"
    $nomOU = Read-Host "Veuillez entrer le nom de l'unite d'organisation"

    try {
        $objetUtilisateur = Get-ADUser -Identity $utilisateur 
    } catch {
        Write-Host "WARNING: L'utilisateur '$utilisateur' n'existe pas dans AD." -ForegroundColor Yellow
        Write-Host "WARNING: L'opération ne peut pas etre completee." -ForegroundColor Yellow
        return
    }

    $ouExist = Get-ADOrganizationalUnit -Filter { Name -eq $nomOU }

    if ($ouExist) {
        $cheminOU = "OU=$nomOU,$domaine"
        Move-ADObject -Identity $objetUtilisateur.DistinguishedName -TargetPath $cheminOU
        Write-Host "L'utilisateur '$utilisateur' a ete deplace vers l'OU '$nomOU'"
    } else {
        Write-Host "WARNING: L'OU '$nomOU' n'existe pas dans AD." -ForegroundColor Yellow
        Write-Host "WARNING: L'operation ne peut pas etre completee." -ForegroundColor Yellow
    }
}

# Boucle principale
do {
    afficherMenu
    do {
        $choix = Read-Host "Indiquez votre choix"
        $valide = $choix -in @("1", "2", "3", "4")
        if (-not $valide) {
            Write-Host "Choix invalide" 
        }
    } while (-not $valide)
    
    switch ($choix) {
        "1" { CreerGroupes }
        "2" { CreerUtilisateurs }
        "3" { CreerOU }
        "4" { placerUtilisateur }
    }

    do {
        $continuer = Read-Host "Voulez-vous revenir au menu ? (o/n)"
        if ($continuer -ne "o" -and $continuer -ne "n") {
            Write-Host "Choix invalide" 
        }
    } while ($continuer -ne "o" -and $continuer -ne "n")

} while ($continuer -eq "o")
