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

# Helper: POST/PATCH com verificação de erro
api_post() {
  local method=$1 url=$2 data=$3
  local response
  response=$(curl -s -X "$method" "$url" \
    -H "$AUTH" -H "Content-Type: application/json" \
    -d "$data")
  if echo "$response" | python3 -c "import sys,json; d=json.load(sys.stdin); exit(1 if 'errors' in d else 0)" 2>/dev/null; then
    echo "$response"
  else
    echo "  ERRO: $response" >&2
    return 1
  fi
}

# ── 0. Limpar flow anterior (se existir) ──
echo "Verificando flows existentes..."
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

# ── 1. Atualizar campo codigo para readonly e não obrigatório ──
echo "Atualizando campo codigo (readonly, não obrigatório)..."
RESULT=$(curl -s -X PATCH "$API/fields/imoveis/codigo" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d '{
    "schema": { "is_nullable": true },
    "meta": {
      "readonly": true,
      "required": false,
      "note": "Auto-gerado no formato IMV-0001"
    }
  }')
if echo "$RESULT" | grep -q '"errors"'; then
  echo "  Aviso: $RESULT"
else
  echo "  Campo atualizado."
fi

# ── 2. Criar Flow ──
echo "Criando flow para gerar código automático..."
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

# ── 3. Op 1 — Run Script (gerar código a partir do ID) ──
# Use single-quoted heredoc to avoid all bash interpolation
echo "Criando operação: gerar código..."
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

echo "  Operação 1 criada: $OP1_ID"

# ── 4. Op 2 — Update Data (salvar código no imóvel) ──
echo "Criando operação: salvar código..."
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

echo "  Operação 2 criada: $OP2_ID"

# ── 5. Encadear: Flow → Op1 → Op2 ──
echo "Encadeando operações..."

# Flow aponta para Op1
curl -s -X PATCH "$API/flows/$FLOW_ID" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d "{\"operation\": \"$OP1_ID\"}" > /dev/null

# Op1 resolve para Op2
curl -s -X PATCH "$API/operations/$OP1_ID" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d "{\"resolve\": \"$OP2_ID\"}" > /dev/null

echo "  Encadeamento configurado."

# ── 6. Backfill: atualizar imóveis existentes com código retroativo ──
echo "Atualizando imóveis existentes com código retroativo..."
IMOVEIS=$(curl -s "$API/items/imoveis?fields=id&sort=id&limit=-1" \
  -H "$AUTH" | python3 -c "
import sys, json
items = json.load(sys.stdin)['data']
for item in items:
    print(item['id'])
")

for ID in $IMOVEIS; do
  CODIGO="IMV-$(printf '%04d' "$ID")"
  curl -s -X PATCH "$API/items/imoveis/$ID" \
    -H "$AUTH" -H "Content-Type: application/json" \
    -d "{\"codigo\": \"$CODIGO\"}" > /dev/null
  echo "  $CODIGO (id=$ID)"
done

echo ""
echo "Pronto! Novos imóveis criados terão código auto-gerado no formato IMV-XXXX."
