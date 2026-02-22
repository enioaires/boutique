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
echo "Criando collection dados_contato..."
curl -sf -X POST "$API/collections" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d '{
    "collection": "dados_contato",
    "meta": {
      "singleton": true,
      "icon": "contact_phone",
      "note": "Dados de contato exibidos no header do site"
    },
    "schema": {}
  }' > /dev/null && echo "  Collection criada." || echo "  Collection já existe."

add_field() {
  local collection=$1 field=$2 type=$3 interface=$4 note=$5
  curl -sf -X POST "$API/fields/$collection" \
    -H "$AUTH" -H "Content-Type: application/json" \
    -d "{
      \"field\": \"$field\",
      \"type\": \"$type\",
      \"meta\": { \"interface\": \"$interface\", \"note\": \"$note\" },
      \"schema\": {}
    }" > /dev/null && echo "  + $field" || echo "  ~ $field (já existe)"
}

echo "Adicionando campos..."
add_field "dados_contato" "telefone"       "string" "input"  "Ex: (31) 99999-9999"
add_field "dados_contato" "telefone_raw"   "string" "input"  "Apenas números com DDI. Ex: 5531999999999"
add_field "dados_contato" "whatsapp"       "string" "input"  "Número do WhatsApp com DDI. Ex: 5531999999999"
add_field "dados_contato" "email"          "string" "input"  "Email de contato"
add_field "dados_contato" "facebook_url"   "string" "input"  "URL completa do Facebook"
add_field "dados_contato" "instagram_url"  "string" "input"  "URL completa do Instagram"
add_field "dados_contato" "youtube_url"    "string" "input"  "URL completa do YouTube"

# Dar acesso público de leitura
echo "Configurando acesso público..."
PUBLIC_POLICY=$(curl -sf --globoff "$API/policies?filter[admin_access][_eq]=false&limit=1" \
  -H "$AUTH" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'][0]['id'])")

curl -sf -X POST "$API/permissions" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d "{
    \"policy\": \"$PUBLIC_POLICY\",
    \"collection\": \"dados_contato\",
    \"action\": \"read\",
    \"fields\": [\"*\"]
  }" > /dev/null && echo "  Acesso público configurado." || echo "  Acesso público já existe."

# Seed com dados iniciais
echo "Inserindo dados iniciais..."
curl -sf -X PATCH "$API/items/dados_contato" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d '{
    "telefone": "(31) 99999-9999",
    "telefone_raw": "5531999999999",
    "whatsapp": "5531999999999",
    "email": "contato@urbanaboutique.com.br",
    "facebook_url": "https://facebook.com/urbanaboutique",
    "instagram_url": "https://instagram.com/urbanaboutique",
    "youtube_url": "https://youtube.com/@urbanaboutique"
  }' > /dev/null && echo "  Dados inseridos."

echo ""
echo "Pronto! Acesse http://localhost:8055/admin/content/dados_contato para editar."
