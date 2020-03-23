# Generateur-SSL-CA
Script Bash pour créer une autorité de certification auto signé et des certificats auto-signé sur un serveur Linux

- Penser au chmod avant de lancer le script
- Les fichiers sont générés dans le repertoire où est lancé le script
- Le serveur devient l'autorité de certification (CA)
- Saisir une passphrase sauvegardée quelque part car demandé au reboot du serveur Web (Apache)
- Saisir un Export Password sauvegardé quelque part car demandé à l'import du pfx dans un gestionnaire de certificat

- Sous Windows, pour Chrome et IE, l'import du "FQDN.pfx" dans le gestionnaire de certificat génère 2 certificats qui sont a stocker dans le magasin "Personnel" puis les copier/coller dans les magasins "Autorités de certification racines de confiance" et "Autorités de certification intermediaires" 
(lors de l'import le mot de passe demandé est le Export Password + cocher les cases 'Marquer cette clé comme exportable' et 'Inclure les propriétés étendues') 

- Pour Firefox : "Options --> Vie privée et sécurité --> Afficher les certificats --> Onglet Autorité --> Importer" --> choisir le fichier "CA_FQDN.pem" et cocher les 2 cases sur le popup
