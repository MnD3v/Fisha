# Utilise une image de base avec Flutter 3.10.6
FROM cirrusci/flutter:3.10.6

# Définis le répertoire de travail dans le conteneur
WORKDIR /app

# Copie les fichiers de ton projet Flutter dans le conteneur
COPY . .

# Exécute les commandes pour installer les dépendances et construire l'application
RUN flutter pub get
RUN flutter build apk --release