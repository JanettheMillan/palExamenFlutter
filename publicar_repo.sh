#!/usr/bin/env bash
# Publica este repo como PÚBLICO en las dos cuentas de GitHub usando tu sesión de gh:
#   - EnriqueLanda2/palExamenFlutter   (remote: origin)
#   - JanettheMillan/palExamenFlutter  (remote: janette)
# Sube las dos ramas: main (solución + kit + guía) y profesor (repo original del profe).
#
#   bash publicar_repo.sh
set -euo pipefail

cd "$(dirname "$0")"
REPO="palExamenFlutter"
DESC="Pre-examen Unidad II: Cafetería UTEZ (Flutter, MVVM, provider) + kit del profe"

# Cuenta activa actual, para dejarla igual al final.
ORIGINAL=$(gh api user --jq .login)

publicar() {
  local cuenta="$1" remote="$2"
  echo
  echo "==== $cuenta ===="
  gh auth switch --hostname github.com --user "$cuenta"
  gh auth setup-git >/dev/null 2>&1 || true
  if gh repo view "$cuenta/$REPO" >/dev/null 2>&1; then
    echo "El repo ya existe; solo se actualiza."
  else
    gh repo create "$cuenta/$REPO" --public --description "$DESC"
  fi
  git remote remove "$remote" 2>/dev/null || true
  git remote add "$remote" "https://github.com/$cuenta/$REPO.git"
  git push -u "$remote" main
  git push "$remote" profesor
  echo "Listo: https://github.com/$cuenta/$REPO"
}

publicar EnriqueLanda2 origin
publicar JanettheMillan janette

gh auth switch --hostname github.com --user "$ORIGINAL" >/dev/null 2>&1 || true
echo
echo "Publicado en las dos cuentas. Cuenta activa de gh: $ORIGINAL"
