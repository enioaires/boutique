#!/bin/bash
set -e

API="http://localhost:8055"

# Login
TOKEN=$(curl -s -X POST "$API/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@imobiliaria.com","password":"admin"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['access_token'])")

echo "Autenticado."

add_field() {
  local result
  result=$(curl -s -X POST "$API/fields/imoveis" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$1")

  local field
  field=$(echo "$1" | python3 -c "import sys,json; print(json.load(sys.stdin)['field'])")

  if echo "$result" | grep -q '"errors"'; then
    echo "  SKIP $field (já existe)"
  else
    echo "  OK   $field"
  fi
}

# ── Identificação ──
echo ""
echo "Identificação:"

add_field '{
  "field": "titulo",
  "type": "string",
  "schema": { "is_nullable": false },
  "meta": { "interface": "input", "width": "full", "required": true, "sort": 5, "note": "Ex: Apartamento 3Q no Belvedere" }
}'

add_field '{
  "field": "codigo",
  "type": "string",
  "schema": { "is_unique": true, "is_nullable": false },
  "meta": { "interface": "input", "width": "half", "required": true, "sort": 6, "note": "Ex: UB123456" }
}'

add_field '{
  "field": "slug",
  "type": "string",
  "schema": { "is_unique": true, "is_nullable": false },
  "meta": { "interface": "input", "width": "half", "required": true, "sort": 7, "note": "Gerado a partir do título, usado na URL" }
}'

add_field '{
  "field": "descricao",
  "type": "text",
  "schema": {},
  "meta": { "interface": "input-rich-text-html", "width": "full", "sort": 8 }
}'

# ── Classificação ──
echo ""
echo "Classificação:"

add_field '{
  "field": "finalidade",
  "type": "string",
  "schema": { "is_nullable": false },
  "meta": {
    "interface": "select-dropdown",
    "width": "half",
    "required": true,
    "sort": 9,
    "options": {
      "choices": [
        { "text": "Compra", "value": "compra" },
        { "text": "Aluguel", "value": "aluguel" }
      ]
    }
  }
}'

add_field '{
  "field": "tipo",
  "type": "string",
  "schema": { "is_nullable": false },
  "meta": {
    "interface": "select-dropdown",
    "width": "half",
    "required": true,
    "sort": 10,
    "options": {
      "choices": [
        { "text": "Apartamento", "value": "apartamento" },
        { "text": "Apartamento Linear", "value": "apartamento-linear" },
        { "text": "Apartamento Duplex", "value": "apartamento-duplex" },
        { "text": "Cobertura", "value": "cobertura" },
        { "text": "Casa", "value": "casa" },
        { "text": "Casa em Condomínio", "value": "casa-condominio" },
        { "text": "Lote", "value": "lote" },
        { "text": "Sala Comercial", "value": "sala-comercial" },
        { "text": "Loja", "value": "loja" },
        { "text": "Galpão", "value": "galpao" },
        { "text": "Andar Corrido", "value": "andar-corrido" }
      ]
    }
  }
}'

add_field '{
  "field": "status",
  "type": "string",
  "schema": { "default_value": "disponivel" },
  "meta": {
    "interface": "select-dropdown",
    "width": "half",
    "sort": 11,
    "options": {
      "choices": [
        { "text": "Disponível", "value": "disponivel" },
        { "text": "Vendido", "value": "vendido" },
        { "text": "Alugado", "value": "alugado" },
        { "text": "Reservado", "value": "reservado" }
      ]
    }
  }
}'

add_field '{
  "field": "destaque",
  "type": "boolean",
  "schema": { "default_value": false },
  "meta": { "interface": "boolean", "width": "half", "sort": 12, "note": "Exibir na página inicial" }
}'

# ── Localização ──
echo ""
echo "Localização:"

add_field '{
  "field": "endereco",
  "type": "string",
  "schema": {},
  "meta": { "interface": "input", "width": "full", "sort": 13 }
}'

add_field '{
  "field": "bairro",
  "type": "string",
  "schema": {},
  "meta": { "interface": "input", "width": "half", "sort": 14 }
}'

add_field '{
  "field": "cidade",
  "type": "string",
  "schema": { "default_value": "Belo Horizonte" },
  "meta": { "interface": "input", "width": "half", "sort": 15 }
}'

add_field '{
  "field": "cep",
  "type": "string",
  "schema": {},
  "meta": { "interface": "input", "width": "half", "sort": 16 }
}'

add_field '{
  "field": "latitude",
  "type": "float",
  "schema": {},
  "meta": { "interface": "input", "width": "half", "sort": 17 }
}'

add_field '{
  "field": "longitude",
  "type": "float",
  "schema": {},
  "meta": { "interface": "input", "width": "half", "sort": 18 }
}'

# ── Características ──
echo ""
echo "Características:"

add_field '{
  "field": "area_total",
  "type": "float",
  "schema": {},
  "meta": { "interface": "input", "width": "half", "sort": 19, "note": "m²" }
}'

add_field '{
  "field": "area_util",
  "type": "float",
  "schema": {},
  "meta": { "interface": "input", "width": "half", "sort": 20, "note": "m²" }
}'

add_field '{
  "field": "quartos",
  "type": "integer",
  "schema": {},
  "meta": { "interface": "input", "width": "half", "sort": 21 }
}'

add_field '{
  "field": "suites",
  "type": "integer",
  "schema": {},
  "meta": { "interface": "input", "width": "half", "sort": 22 }
}'

add_field '{
  "field": "banheiros",
  "type": "integer",
  "schema": {},
  "meta": { "interface": "input", "width": "half", "sort": 23 }
}'

add_field '{
  "field": "vagas",
  "type": "integer",
  "schema": {},
  "meta": { "interface": "input", "width": "half", "sort": 24 }
}'

add_field '{
  "field": "andar",
  "type": "integer",
  "schema": {},
  "meta": { "interface": "input", "width": "half", "sort": 25, "note": "Deixar vazio para casa/lote" }
}'

# ── Financeiro ──
echo ""
echo "Financeiro:"

add_field '{
  "field": "preco_venda",
  "type": "decimal",
  "schema": { "numeric_precision": 12, "numeric_scale": 2 },
  "meta": { "interface": "input", "width": "half", "sort": 26, "note": "R$" }
}'

add_field '{
  "field": "preco_aluguel",
  "type": "decimal",
  "schema": { "numeric_precision": 10, "numeric_scale": 2 },
  "meta": { "interface": "input", "width": "half", "sort": 27, "note": "R$ / mês" }
}'

add_field '{
  "field": "condominio",
  "type": "decimal",
  "schema": { "numeric_precision": 10, "numeric_scale": 2 },
  "meta": { "interface": "input", "width": "half", "sort": 28, "note": "R$ / mês" }
}'

add_field '{
  "field": "iptu",
  "type": "decimal",
  "schema": { "numeric_precision": 10, "numeric_scale": 2 },
  "meta": { "interface": "input", "width": "half", "sort": 29, "note": "R$ / ano" }
}'

# ── Mídia ──
echo ""
echo "Mídia:"

add_field '{
  "field": "imagem_destaque",
  "type": "uuid",
  "schema": {},
  "meta": { "interface": "file-image", "special": ["file"], "width": "full", "sort": 30 }
}'

add_field '{
  "field": "galeria",
  "type": "alias",
  "meta": { "interface": "files", "special": ["files"], "width": "full", "sort": 31 }
}'

add_field '{
  "field": "video_url",
  "type": "string",
  "schema": {},
  "meta": { "interface": "input", "width": "full", "sort": 32, "note": "Link do YouTube ou Vimeo" }
}'

# ── Extras ──
echo ""
echo "Extras:"

add_field '{
  "field": "caracteristicas",
  "type": "json",
  "schema": {},
  "meta": { "interface": "tags", "width": "full", "sort": 33, "note": "Ex: Piscina, Churrasqueira, Academia, Varanda" }
}'

echo ""
echo "Setup concluído!"
