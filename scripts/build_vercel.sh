#!/bin/bash
set -e

echo "==> Clonando Flutter SDK (stable)..."
git clone https://github.com/flutter/flutter.git --branch stable --depth 1 /tmp/flutter

export PATH="$PATH:/tmp/flutter/bin"

echo "==> Configurando Flutter para web..."
flutter config --enable-web --no-analytics

echo "==> Baixando dependências..."
flutter pub get

echo "==> Gerando build web..."
flutter build web --release

echo "==> Build finalizado com sucesso!"
