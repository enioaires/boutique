#!/bin/bash
set -e

API="http://localhost:8055"

# Login
TOKEN=$(curl -s -X POST "$API/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@imobiliaria.com","password":"admin"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['access_token'])")

echo "Autenticado."

AUTH="Authorization: Bearer $TOKEN"

# Criar collection (singleton)
echo "Criando collection dados_gerais..."
curl -sf -X POST "$API/collections" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d '{
    "collection": "dados_gerais",
    "meta": {
      "singleton": true,
      "icon": "settings",
      "note": "Configurações gerais do site"
    },
    "schema": {}
  }' > /dev/null && echo "  Collection criada." || echo "  Collection já existe."

# Campo imagem_hero (file relation)
echo "Adicionando campo imagem_hero..."
curl -sf -X POST "$API/fields/dados_gerais" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d '{
    "field": "imagem_hero",
    "type": "uuid",
    "meta": {
      "interface": "file-image",
      "special": ["file"],
      "note": "Imagem exibida na seção hero da página inicial"
    },
    "schema": {}
  }' > /dev/null && echo "  + imagem_hero" || echo "  ~ imagem_hero (já existe)"

# Dar acesso público de leitura
echo "Configurando acesso público..."
PUBLIC_POLICY=$(curl -sf --globoff "$API/policies?filter[admin_access][_eq]=false&limit=1" \
  -H "$AUTH" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'][0]['id'])")

curl -sf -X POST "$API/permissions" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d "{
    \"policy\": \"$PUBLIC_POLICY\",
    \"collection\": \"dados_gerais\",
    \"action\": \"read\",
    \"fields\": [\"*\"]
  }" > /dev/null && echo "  Acesso público configurado." || echo "  Acesso público já existe."

echo ""
echo "Pronto! Acesse http://localhost:8055/admin/content/dados_gerais para editar."
