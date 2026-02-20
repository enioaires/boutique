#!/bin/bash
set -e

API="http://localhost:8055"

TOKEN=$(curl -s -X POST "$API/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@imobiliaria.com","password":"admin"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['access_token'])")

echo "Autenticado."

# ═══════════════════════════════════════
# 1. Collection: tipos_imoveis
# ═══════════════════════════════════════
echo ""
echo "=== Criando collection tipos_imoveis ==="

curl -s -X POST "$API/collections" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "collection": "tipos_imoveis",
    "meta": {
      "icon": "category",
      "note": "Tipos de imóveis disponíveis",
      "display_template": "{{nome}}",
      "sort_field": "sort"
    },
    "schema": {},
    "fields": [
      { "field": "id", "type": "integer", "schema": { "is_primary_key": true, "has_auto_increment": true }, "meta": { "hidden": true, "readonly": true } },
      { "field": "sort", "type": "integer", "schema": {}, "meta": { "hidden": true } },
      { "field": "nome", "type": "string", "schema": { "is_nullable": false }, "meta": { "interface": "input", "width": "half", "required": true, "sort": 3 } },
      { "field": "slug", "type": "string", "schema": { "is_unique": true, "is_nullable": false }, "meta": { "interface": "input", "width": "half", "required": true, "sort": 4, "special": ["slug"] } },
      { "field": "categoria", "type": "string", "schema": { "is_nullable": false }, "meta": { "interface": "select-dropdown", "width": "half", "required": true, "sort": 5, "options": { "choices": [{ "text": "Residencial", "value": "residencial" }, { "text": "Comercial", "value": "comercial" }] } } }
    ]
  }' > /dev/null 2>&1 && echo "  OK collection" || echo "  SKIP (já existe)"

# Seed tipos
echo ""
echo "  Populando tipos..."

seed_tipo() {
  curl -s -X POST "$API/items/tipos_imoveis" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$1" > /dev/null 2>&1 && echo "    OK $2" || echo "    SKIP $2"
}

seed_tipo '{"nome":"Apartamento","slug":"apartamento","categoria":"residencial","sort":1}' "Apartamento"
seed_tipo '{"nome":"Apartamento Linear","slug":"apartamento-linear","categoria":"residencial","sort":2}' "Apartamento Linear"
seed_tipo '{"nome":"Apartamento Duplex","slug":"apartamento-duplex","categoria":"residencial","sort":3}' "Apartamento Duplex"
seed_tipo '{"nome":"Cobertura","slug":"cobertura","categoria":"residencial","sort":4}' "Cobertura"
seed_tipo '{"nome":"Casa","slug":"casa","categoria":"residencial","sort":5}' "Casa"
seed_tipo '{"nome":"Casa em Condomínio","slug":"casa-condominio","categoria":"residencial","sort":6}' "Casa em Condomínio"
seed_tipo '{"nome":"Lote","slug":"lote","categoria":"residencial","sort":7}' "Lote"
seed_tipo '{"nome":"Sala Comercial","slug":"sala-comercial","categoria":"comercial","sort":8}' "Sala Comercial"
seed_tipo '{"nome":"Loja","slug":"loja","categoria":"comercial","sort":9}' "Loja"
seed_tipo '{"nome":"Galpão","slug":"galpao","categoria":"comercial","sort":10}' "Galpão"
seed_tipo '{"nome":"Andar Corrido","slug":"andar-corrido","categoria":"comercial","sort":11}' "Andar Corrido"

# ═══════════════════════════════════════
# 2. Collection: localizacoes
# ═══════════════════════════════════════
echo ""
echo "=== Criando collection localizacoes ==="

curl -s -X POST "$API/collections" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "collection": "localizacoes",
    "meta": {
      "icon": "location_on",
      "note": "Bairros e cidades atendidos",
      "display_template": "{{nome}} — {{regiao}}",
      "sort_field": "sort"
    },
    "schema": {},
    "fields": [
      { "field": "id", "type": "integer", "schema": { "is_primary_key": true, "has_auto_increment": true }, "meta": { "hidden": true, "readonly": true } },
      { "field": "sort", "type": "integer", "schema": {}, "meta": { "hidden": true } },
      { "field": "nome", "type": "string", "schema": { "is_nullable": false }, "meta": { "interface": "input", "width": "half", "required": true, "sort": 3 } },
      { "field": "slug", "type": "string", "schema": { "is_unique": true, "is_nullable": false }, "meta": { "interface": "input", "width": "half", "required": true, "sort": 4, "special": ["slug"] } },
      { "field": "regiao", "type": "string", "schema": { "is_nullable": false }, "meta": { "interface": "select-dropdown", "width": "half", "required": true, "sort": 5, "options": { "choices": [{ "text": "Belo Horizonte", "value": "belo-horizonte" }, { "text": "Grande BH", "value": "grande-bh" }] } } }
    ]
  }' > /dev/null 2>&1 && echo "  OK collection" || echo "  SKIP (já existe)"

# Seed localizações
echo ""
echo "  Populando localizações..."

seed_loc() {
  curl -s -X POST "$API/items/localizacoes" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$1" > /dev/null 2>&1 && echo "    OK $2" || echo "    SKIP $2"
}

seed_loc '{"nome":"Savassi","slug":"savassi","regiao":"belo-horizonte","sort":1}' "Savassi"
seed_loc '{"nome":"Funcionários","slug":"funcionarios","regiao":"belo-horizonte","sort":2}' "Funcionários"
seed_loc '{"nome":"Lourdes","slug":"lourdes","regiao":"belo-horizonte","sort":3}' "Lourdes"
seed_loc '{"nome":"Belvedere","slug":"belvedere","regiao":"belo-horizonte","sort":4}' "Belvedere"
seed_loc '{"nome":"Sion","slug":"sion","regiao":"belo-horizonte","sort":5}' "Sion"
seed_loc '{"nome":"Serra","slug":"serra","regiao":"belo-horizonte","sort":6}' "Serra"
seed_loc '{"nome":"Santo Agostinho","slug":"santo-agostinho","regiao":"belo-horizonte","sort":7}' "Santo Agostinho"
seed_loc '{"nome":"Mangabeiras","slug":"mangabeiras","regiao":"belo-horizonte","sort":8}' "Mangabeiras"
seed_loc '{"nome":"Buritis","slug":"buritis","regiao":"belo-horizonte","sort":9}' "Buritis"
seed_loc '{"nome":"Pampulha","slug":"pampulha","regiao":"belo-horizonte","sort":10}' "Pampulha"
seed_loc '{"nome":"Santa Amélia","slug":"santa-amelia","regiao":"belo-horizonte","sort":11}' "Santa Amélia"
seed_loc '{"nome":"Nova Lima","slug":"nova-lima","regiao":"grande-bh","sort":12}' "Nova Lima"
seed_loc '{"nome":"Contagem","slug":"contagem","regiao":"grande-bh","sort":13}' "Contagem"
seed_loc '{"nome":"Betim","slug":"betim","regiao":"grande-bh","sort":14}' "Betim"
seed_loc '{"nome":"Santa Luzia","slug":"santa-luzia","regiao":"grande-bh","sort":15}' "Santa Luzia"
seed_loc '{"nome":"Sabará","slug":"sabara","regiao":"grande-bh","sort":16}' "Sabará"
seed_loc '{"nome":"Lagoa Santa","slug":"lagoa-santa","regiao":"grande-bh","sort":17}' "Lagoa Santa"

# ═══════════════════════════════════════
# 3. Atualizar imoveis: trocar campos string por M2O
# ═══════════════════════════════════════
echo ""
echo "=== Atualizando imoveis com relações ==="

# Remover campos antigos (string)
for field in tipo bairro cidade; do
  curl -s -X DELETE "$API/fields/imoveis/$field" \
    -H "Authorization: Bearer $TOKEN" > /dev/null 2>&1
  echo "  Removido campo: $field"
done

# Criar campo M2O: tipo_imovel → tipos_imoveis
curl -s -X POST "$API/fields/imoveis" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "field": "tipo_imovel",
    "type": "integer",
    "schema": {},
    "meta": {
      "interface": "select-dropdown-m2o",
      "special": ["m2o"],
      "width": "half",
      "sort": 10,
      "required": true,
      "display": "related-values",
      "display_options": { "template": "{{nome}}" }
    }
  }' > /dev/null 2>&1 && echo "  OK campo tipo_imovel"

# Criar relação M2O
curl -s -X POST "$API/relations" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "collection": "imoveis",
    "field": "tipo_imovel",
    "related_collection": "tipos_imoveis"
  }' > /dev/null 2>&1 && echo "  OK relação tipo_imovel → tipos_imoveis"

# Criar campo M2O: localizacao → localizacoes
curl -s -X POST "$API/fields/imoveis" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "field": "localizacao",
    "type": "integer",
    "schema": {},
    "meta": {
      "interface": "select-dropdown-m2o",
      "special": ["m2o"],
      "width": "half",
      "sort": 13,
      "required": true,
      "display": "related-values",
      "display_options": { "template": "{{nome}}" }
    }
  }' > /dev/null 2>&1 && echo "  OK campo localizacao"

curl -s -X POST "$API/relations" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "collection": "imoveis",
    "field": "localizacao",
    "related_collection": "localizacoes"
  }' > /dev/null 2>&1 && echo "  OK relação localizacao → localizacoes"

# ═══════════════════════════════════════
# 4. Atualizar imóveis existentes com IDs das relações
# ═══════════════════════════════════════
echo ""
echo "=== Vinculando imóveis existentes ==="

# Buscar IDs dos tipos
get_tipo_id() {
  curl -s "$API/items/tipos_imoveis?filter[slug][_eq]=$1&fields=id" \
    -H "Authorization: Bearer $TOKEN" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'][0]['id'])"
}

# Buscar IDs das localizações
get_loc_id() {
  curl -s "$API/items/localizacoes?filter[slug][_eq]=$1&fields=id" \
    -H "Authorization: Bearer $TOKEN" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'][0]['id'])"
}

update_imovel() {
  local id=$1 tipo_id=$2 loc_id=$3
  curl -s -X PATCH "$API/items/imoveis/$id" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"tipo_imovel\":$tipo_id,\"localizacao\":$loc_id}" > /dev/null 2>&1
  echo "  OK imovel #$id"
}

# Mapear cada imóvel: (id, slug_tipo, slug_localizacao)
update_imovel 1 "$(get_tipo_id apartamento)" "$(get_loc_id buritis)"
update_imovel 2 "$(get_tipo_id apartamento)" "$(get_loc_id funcionarios)"
update_imovel 3 "$(get_tipo_id casa)" "$(get_loc_id santa-amelia)"
update_imovel 4 "$(get_tipo_id apartamento)" "$(get_loc_id savassi)"
update_imovel 5 "$(get_tipo_id sala-comercial)" "$(get_loc_id lourdes)"
update_imovel 6 "$(get_tipo_id cobertura)" "$(get_loc_id sion)"
update_imovel 7 "$(get_tipo_id lote)" "$(get_loc_id lagoa-santa)"
update_imovel 8 "$(get_tipo_id apartamento)" "$(get_loc_id pampulha)"
update_imovel 9 "$(get_tipo_id casa-condominio)" "$(get_loc_id nova-lima)"
update_imovel 10 "$(get_tipo_id loja)" "$(get_loc_id serra)"

echo ""
echo "Setup concluído!"
