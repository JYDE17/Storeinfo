# GoPlex — Impression des reçus (QZ Tray)

Application locale pour imprimer les infos du centre sur un reçu pro avec le
logo GoPlex (imprimante thermique 58 mm / 80 mm ou n'importe quelle imprimante).

Aux couleurs de la marque : **Noir #000000** et **Or #D5A62E**.
Le reçu imprime le logo en **noir & blanc** (le thermique n'imprime qu'en noir).

## Fichiers

| Fichier | Rôle |
|---|---|
| `index.html` | L'application (à ouvrir dans un navigateur) |
| `config.js` | **Tes infos** : nom, adresse, tél., courriel, heures, employés |
| `logo.js` | Logos GoPlex intégrés (couleur + N&B) — ne pas modifier |
| `logo-color.png` / `logo-print.png` | Sources des logos (référence) |
| `qr.js` / `qr-google.png` | QR code de l'avis Google (reçu « Avis Google ») |
| `qz-tray.js` | Librairie QZ Tray (fournie) |
| `jsrsasign-all-min.js` | Librairie de signature (fournie) |
| `signing/` | Certificat + clé privée (**déjà générés**) pour l'impression silencieuse |
| `signing.js` | Clé **embarquée** — permet la signature en ouvrant `index.html` en `file://` |
| `Installer-certificat-QZ.bat` | À lancer **une fois par POS** pour l'impression 100 % silencieuse |

Imprimantes visées : **Epson TM-T88V** (papier 80 mm) — l'app la sélectionne
automatiquement si elle est détectée.

## Disque externe

L'app fonctionne depuis un disque externe, **peu importe la lettre** (D:, E:, F:…) :
tout est en chemins relatifs, et la clé de signature est embarquée dans `signing.js`
(donc pas de blocage `fetch` quand on ouvre `index.html` directement).

Seule chose spécifique à chaque ordinateur : la liste blanche de QZ Tray
(`override.crt`). Il faut donc lancer `Installer-certificat-QZ.bat`
**une fois sur chaque POS** où tu brancheras le disque.

## Première installation (par POS)

1. Installe et démarre **QZ Tray** : https://qz.io/download/
2. Branche le disque, double-clique **`Installer-certificat-QZ.bat`**
   (approuve la demande admin).
   → Les reçus s'imprimeront sans aucune fenêtre de confirmation.

Ensuite, au quotidien, il suffit d'ouvrir `index.html` et de cliquer un reçu.

## Utilisation quotidienne

1. Assure-toi que **l'application QZ Tray** est démarrée (icône dans la barre des tâches).
   Téléchargement : https://qz.io/download/
2. Ouvre `index.html` (double-clic).
3. **Clique un reçu → il s'imprime directement.** La connexion à QZ Tray se fait
   toute seule au premier clic. Un message « ✓ Reçu imprimé » confirme.

Le papier est réglé sur **80 mm** par défaut (bon pour la TM-T88V). Change-le
en haut si besoin. Le bouton « Connecter QZ Tray » sert seulement à vérifier
l'état à l'avance ; ce n'est pas obligatoire.

Pour changer tes coordonnées ou ajouter un employé : ouvre `config.js`,
modifie, sauvegarde, recharge la page. Aucune autre étape.

---

## Impression silencieuse (déjà configurée)

Le certificat et la clé privée sont **déjà générés** dans `signing/` :
- `signing/private-key.pem` — clé privée (garde-la sur le POS, ne la partage pas)
- `signing/digital-certificate.txt` — certificat public (valide jusqu'en 2036)

L'app les utilise automatiquement. Il reste **une seule étape** pour que QZ Tray
fasse confiance à ce certificat et n'affiche plus la fenêtre de confirmation.

Comme les reçus sont **signés** (clé dans `signing.js`), tu as deux façons de
ne plus voir la fenêtre :

**Rapide** — à la fenêtre « Action Required », coche **« Remember this decision »**
PUIS clique **« Allow »**. Comme c'est signé, QZ mémorise le choix (ça ne
fonctionne pas si ce n'est pas signé — d'où la clé). Il ne redemandera plus.

**Définitif (recommandé)** — l'installateur `override.crt` ci-dessous : plus
jamais aucune fenêtre, sur ce POS, pour toujours.

### Installer le certificat (le plus simple)

**Double-clique `Installer-certificat-QZ.bat`.**
Il demande les droits administrateur, copie le certificat dans le dossier de
QZ Tray et redémarre QZ Tray. C'est tout — les reçus s'impriment ensuite sans
aucune fenêtre.

### Méthode manuelle (si tu préfères)

1. Ouvre `C:\Program Files\QZ Tray\`.
2. Copie le contenu de `signing/digital-certificate.txt`.
3. Colle-le dans un fichier nommé **`override.crt`** dans ce dossier
   (crée-le s'il n'existe pas).
4. Redémarre QZ Tray.

Détails officiels : https://qz.io/wiki/2-1-signing-messages

### Regénérer la clé (si un jour nécessaire)

```bash
openssl req -x509 -newkey rsa:2048 -keyout signing/private-key.pem \
  -out signing/digital-certificate.txt -days 3650 -nodes \
  -subj "/CN=GoPlex E-Karting/O=GoPlex Inc/C=CA"
```
