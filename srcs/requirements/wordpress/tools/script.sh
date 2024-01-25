#!/bin/sh

# Fonction pour afficher un message en vert
log_success() {
  echo -e "\033[32m[ENTRY SCRIPT] $1\033[0m"  # Vert
}

# Fonction pour afficher un message en jaune
log_wait() {
  echo -e "\033[33m[ENTRY SCRIPT] $1\033[0m"  # Jaune
}

# Fonction pour afficher un message en bleu
log_info() {
  echo -e "\033[34m[ENTRY SCRIPT] $1\033[0m"  # Bleu
}

# Attendre que MariaDB soit en cours d'exécution
sleep 1
log_info "Attente du démarrage de MariaDB..."
while ! mysqladmin ping -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
  log_info "En attente du démarrage de MariaDB..."
  sleep 1
done
log_success "MariaDB est en cours d'exécution."

# Attendre que la base de données soit créée
sleep 1
log_info "Attente de la création de la base de données WordPress..."
while ! mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" -e "USE $DB_NAME" 2>/dev/null; do
  log_info "En attente de la création de la base de données WordPress..."
  sleep 1
done
log_success "Base de données WordPress créée avec succès."

# Créer la configuration WordPress
sleep 1
log_success "Création de la configuration WordPress..."
wp config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost="$DB_HOST" --locale="ca_FR" --path="/var/www/wordpress"
log_success "Configuration WordPress créée avec succès."

# Installer WordPress
sleep 1
log_success "Installation de WordPress..."
wp core install --url="$WP_DOMAIN" --title="$DB_NAME" --admin_user="$WP_ADMIN" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_EMAIL" --skip-email --path="/var/www/wordpress"
log_success "WordPress installé avec succès."

# Créer un utilisateur WordPress
sleep 1
log_success "Création de l'utilisateur WordPress..."
wp user create "$WP_USER" "$WP_USER_EMAIL" --role=author --user_pass="$WP_USER_PASSWORD" --path="/var/www/wordpress"
log_success "Utilisateur WordPress créé avec succès."

# Démarrer PHP-FPM
sleep 1
log_info "Démarrage de PHP-FPM..."
php-fpm81 --nodaemonize
log_success "PHP-FPM est démarré avec succès."
