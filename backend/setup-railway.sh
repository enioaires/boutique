#!/bin/bash
set -e

API="${1:?Uso: ./setup-railway.sh https://sua-url.up.railway.app}"

# Login
TOKEN=$(curl -s -X POST "$API/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@imobiliaria.com","password":"admin"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['access_token'])")

echo "Autenticado em $API"
AUTH="Authorization: Bearer $TOKEN"

# ── Obter policy pública ──
PUBLIC_POLICY=$(curl -sf --globoff "$API/policies?filter[admin_access][_eq]=false&limit=1" \
  -H "$AUTH" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'][0]['id'])")
echo "Policy pública: $PUBLIC_POLICY"

# ── Permissões públicas de leitura ──
grant_read() {
  local collection=$1
  curl -sf -X POST "$API/permissions" \
    -H "$AUTH" -H "Content-Type: application/json" \
    -d "{
      \"policy\": \"$PUBLIC_POLICY\",
      \"collection\": \"$collection\",
      \"action\": \"read\",
      \"fields\": [\"*\"]
    }" > /dev/null 2>&1 && echo "  + $collection" || echo "  ~ $collection (já existe)"
}

echo ""
echo "Configurando permissões públicas de leitura..."
grant_read "imoveis"
grant_read "imoveis_files"
grant_read "tipos_imoveis"
grant_read "localizacoes"
grant_read "dados_contato"
grant_read "dados_gerais"
grant_read "directus_files"

# ── Seed dados_contato ──
echo ""
echo "Inserindo dados iniciais de contato..."
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
  }' > /dev/null && echo "  Dados de contato inseridos."

# ── Flow: gerar código automático do imóvel ──
echo ""
echo "Configurando flow de código automático..."

# Limpar flow anterior (se existir)
EXISTING=$(curl -s --globoff "$API/flows?filter[name][_eq]=Gerar+código+do+imóvel" \
  -H "$AUTH" | python3 -c "
import sys, json
data = json.load(sys.stdin)['data']
for f in data:
    print(f['id'])
" 2>/dev/null || true)

for FID in $EXISTING; do
  echo "  Removendo flow anterior: $FID"
  curl -s -X DELETE "$API/flows/$FID" -H "$AUTH" > /dev/null
done

# Campo codigo → readonly
curl -s -X PATCH "$API/fields/imoveis/codigo" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d '{
    "schema": { "is_nullable": true },
    "meta": {
      "readonly": true,
      "required": false,
      "note": "Auto-gerado no formato IMV-0001"
    }
  }' > /dev/null && echo "  Campo codigo atualizado."

# Criar flow
FLOW_ID=$(curl -s -X POST "$API/flows" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d '{
    "name": "Gerar código do imóvel",
    "icon": "tag",
    "description": "Auto-gera o campo codigo no formato IMV-XXXX ao criar um imóvel",
    "status": "active",
    "trigger": "event",
    "accountability": "all",
    "options": {
      "type": "action",
      "scope": ["items.create"],
      "collections": ["imoveis"]
    }
  }' | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])")
echo "  Flow criado: $FLOW_ID"

# Op 1: gerar código
OP1_PAYLOAD=$(cat <<'ENDJSON'
{
  "name": "Gerar código",
  "key": "gerar_codigo",
  "type": "exec",
  "position_x": 19,
  "position_y": 1,
  "options": {
    "code": "module.exports = async function(data) { return 'IMV-' + String(data.$trigger.key).padStart(4, '0'); }"
  },
  "flow": "FLOW_PLACEHOLDER"
}
ENDJSON
)
OP1_PAYLOAD="${OP1_PAYLOAD//FLOW_PLACEHOLDER/$FLOW_ID}"

OP1_ID=$(curl -s -X POST "$API/operations" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d "$OP1_PAYLOAD" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])")
echo "  Op1 criada: $OP1_ID"

# Op 2: salvar código
OP2_PAYLOAD=$(cat <<'ENDJSON'
{
  "name": "Salvar código no imóvel",
  "key": "salvar_codigo",
  "type": "item-update",
  "position_x": 37,
  "position_y": 1,
  "options": {
    "collection": "imoveis",
    "key": "{{$trigger.key}}",
    "payload": {
      "codigo": "{{$last}}"
    }
  },
  "flow": "FLOW_PLACEHOLDER"
}
ENDJSON
)
OP2_PAYLOAD="${OP2_PAYLOAD//FLOW_PLACEHOLDER/$FLOW_ID}"

OP2_ID=$(curl -s -X POST "$API/operations" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d "$OP2_PAYLOAD" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])")
echo "  Op2 criada: $OP2_ID"

# Encadear: Flow → Op1 → Op2
curl -s -X PATCH "$API/flows/$FLOW_ID" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d "{\"operation\": \"$OP1_ID\"}" > /dev/null

curl -s -X PATCH "$API/operations/$OP1_ID" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d "{\"resolve\": \"$OP2_ID\"}" > /dev/null
echo "  Flow encadeado."

echo ""
echo "Pronto! Railway configurado."
echo "  Painel: $API"
