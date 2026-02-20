#!/bin/bash
set -e

API="http://localhost:8055"

TOKEN=$(curl -s -X POST "$API/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@imobiliaria.com","password":"admin"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['access_token'])")

echo "Autenticado."

add_imovel() {
  local titulo
  titulo=$(echo "$1" | python3 -c "import sys,json; print(json.load(sys.stdin)['titulo'])")

  local result
  result=$(curl -s -X POST "$API/items/imoveis" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$1")

  if echo "$result" | grep -q '"errors"'; then
    echo "  ERRO $titulo"
    echo "$result" | python3 -c "import sys,json; print('       ', json.load(sys.stdin)['errors'][0]['message'])" 2>/dev/null
  else
    echo "  OK   $titulo"
  fi
}

echo ""
echo "Criando imóveis..."

# 1
add_imovel '{
  "titulo": "Apartamento 2 Quartos no Buritis",
  "slug": "apartamento-2q-buritis",
  "descricao": "<p>Apartamento bem localizado no bairro Buritis, próximo a comércios e transporte público. Sala ampla com varanda, cozinha planejada e área de serviço.</p>",
  "finalidade": "compra",
  "tipo": "apartamento",
  "status": "disponivel",
  "destaque": true,
  "endereco": "Rua Platina, 220",
  "bairro": "Buritis",
  "cidade": "Belo Horizonte",
  "cep": "30575-100",
  "area_total": 68,
  "area_util": 58,
  "quartos": 2,
  "suites": 1,
  "banheiros": 2,
  "vagas": 1,
  "andar": 5,
  "preco_venda": 380000,
  "condominio": 650,
  "iptu": 1800,
  "caracteristicas": ["Varanda", "Cozinha planejada", "Elevador", "Portaria 24h"]
}'

# 2
add_imovel '{
  "titulo": "Apartamento 3 Quartos em Funcionários",
  "slug": "apartamento-3q-funcionarios",
  "descricao": "<p>Apartamento espaçoso em uma das melhores localizações de BH. Três quartos com armários, sala para dois ambientes e vista livre.</p>",
  "finalidade": "compra",
  "tipo": "apartamento",
  "status": "disponivel",
  "destaque": true,
  "endereco": "Rua Antônio de Albuquerque, 85",
  "bairro": "Funcionários",
  "cidade": "Belo Horizonte",
  "cep": "30112-010",
  "area_total": 95,
  "area_util": 82,
  "quartos": 3,
  "suites": 1,
  "banheiros": 2,
  "vagas": 2,
  "andar": 8,
  "preco_venda": 720000,
  "condominio": 980,
  "iptu": 3200,
  "caracteristicas": ["Armários embutidos", "Vista livre", "Portaria 24h", "Salão de festas"]
}'

# 3
add_imovel '{
  "titulo": "Casa 3 Quartos no Santa Amélia",
  "slug": "casa-3q-santa-amelia",
  "descricao": "<p>Casa com quintal em rua tranquila. Três quartos, sala, cozinha, área de serviço e garagem coberta para dois carros.</p>",
  "finalidade": "compra",
  "tipo": "casa",
  "status": "disponivel",
  "destaque": false,
  "endereco": "Rua das Canoas, 340",
  "bairro": "Santa Amélia",
  "cidade": "Belo Horizonte",
  "cep": "31555-120",
  "area_total": 200,
  "area_util": 120,
  "quartos": 3,
  "suites": 0,
  "banheiros": 2,
  "vagas": 2,
  "preco_venda": 490000,
  "iptu": 2100,
  "caracteristicas": ["Quintal", "Garagem coberta", "Rua tranquila"]
}'

# 4
add_imovel '{
  "titulo": "Apartamento 1 Quarto na Savassi",
  "slug": "apartamento-1q-savassi",
  "descricao": "<p>Studio moderno na Savassi, ideal para jovens profissionais. Totalmente mobiliado, pronto para morar.</p>",
  "finalidade": "aluguel",
  "tipo": "apartamento",
  "status": "disponivel",
  "destaque": true,
  "endereco": "Rua Pernambuco, 1100",
  "bairro": "Savassi",
  "cidade": "Belo Horizonte",
  "cep": "30130-150",
  "area_total": 38,
  "area_util": 35,
  "quartos": 1,
  "suites": 0,
  "banheiros": 1,
  "vagas": 1,
  "andar": 12,
  "preco_aluguel": 2200,
  "condominio": 520,
  "iptu": 900,
  "caracteristicas": ["Mobiliado", "Academia", "Rooftop", "Pet friendly"]
}'

# 5
add_imovel '{
  "titulo": "Sala Comercial no Lourdes",
  "slug": "sala-comercial-lourdes",
  "descricao": "<p>Sala comercial em prédio corporativo com recepção, ar-condicionado central e estacionamento rotativo.</p>",
  "finalidade": "aluguel",
  "tipo": "sala-comercial",
  "status": "disponivel",
  "destaque": false,
  "endereco": "Av. do Contorno, 4520",
  "bairro": "Lourdes",
  "cidade": "Belo Horizonte",
  "cep": "30110-028",
  "area_total": 45,
  "area_util": 42,
  "quartos": 0,
  "suites": 0,
  "banheiros": 1,
  "vagas": 1,
  "andar": 6,
  "preco_aluguel": 3500,
  "condominio": 850,
  "iptu": 1500,
  "caracteristicas": ["Ar-condicionado central", "Recepção", "Prédio corporativo"]
}'

# 6
add_imovel '{
  "titulo": "Cobertura Duplex no Sion",
  "slug": "cobertura-duplex-sion",
  "descricao": "<p>Cobertura duplex com terraço, churrasqueira e vista para a Serra do Curral. Piso superior com suíte master e closet.</p>",
  "finalidade": "compra",
  "tipo": "cobertura",
  "status": "disponivel",
  "destaque": true,
  "endereco": "Rua Grão Mogol, 450",
  "bairro": "Sion",
  "cidade": "Belo Horizonte",
  "cep": "30310-010",
  "area_total": 180,
  "area_util": 155,
  "quartos": 3,
  "suites": 2,
  "banheiros": 3,
  "vagas": 3,
  "preco_venda": 1250000,
  "condominio": 1400,
  "iptu": 5800,
  "caracteristicas": ["Churrasqueira", "Terraço", "Vista Serra do Curral", "Closet", "Piscina"]
}'

# 7
add_imovel '{
  "titulo": "Lote em Lagoa Santa",
  "slug": "lote-lagoa-santa",
  "descricao": "<p>Lote plano em condomínio fechado com infraestrutura completa. Próximo à Lagoa Central e fácil acesso pela MG-010.</p>",
  "finalidade": "compra",
  "tipo": "lote",
  "status": "disponivel",
  "destaque": false,
  "endereco": "Condomínio Jardins da Lagoa, Lote 42",
  "bairro": "Centro",
  "cidade": "Lagoa Santa",
  "cep": "33400-000",
  "area_total": 360,
  "preco_venda": 195000,
  "caracteristicas": ["Condomínio fechado", "Lote plano", "Infraestrutura completa"]
}'

# 8
add_imovel '{
  "titulo": "Apartamento 2 Quartos na Pampulha",
  "slug": "apartamento-2q-pampulha",
  "descricao": "<p>Apartamento próximo à Lagoa da Pampulha com dois quartos, varanda gourmet e lazer completo no condomínio.</p>",
  "finalidade": "aluguel",
  "tipo": "apartamento",
  "status": "disponivel",
  "destaque": false,
  "endereco": "Av. Portugal, 2100",
  "bairro": "Pampulha",
  "cidade": "Belo Horizonte",
  "cep": "31310-260",
  "area_total": 72,
  "area_util": 62,
  "quartos": 2,
  "suites": 1,
  "banheiros": 2,
  "vagas": 1,
  "andar": 3,
  "preco_aluguel": 1800,
  "condominio": 580,
  "iptu": 1400,
  "caracteristicas": ["Varanda gourmet", "Piscina", "Playground", "Churrasqueira"]
}'

# 9
add_imovel '{
  "titulo": "Casa em Condomínio em Nova Lima",
  "slug": "casa-condominio-nova-lima",
  "descricao": "<p>Casa em condomínio com segurança 24h, área verde e lazer. Quatro quartos, suíte master com closet, jardim privativo.</p>",
  "finalidade": "compra",
  "tipo": "casa-condominio",
  "status": "reservado",
  "destaque": true,
  "endereco": "Condomínio Vila Real, Casa 15",
  "bairro": "Vila da Serra",
  "cidade": "Nova Lima",
  "cep": "34000-000",
  "area_total": 350,
  "area_util": 220,
  "quartos": 4,
  "suites": 2,
  "banheiros": 4,
  "vagas": 3,
  "preco_venda": 980000,
  "condominio": 1200,
  "iptu": 4500,
  "caracteristicas": ["Jardim privativo", "Segurança 24h", "Área verde", "Closet"]
}'

# 10
add_imovel '{
  "titulo": "Loja no Serra",
  "slug": "loja-serra",
  "descricao": "<p>Loja de esquina com boa visibilidade, vitrine ampla e mezanino. Ideal para comércio ou serviços.</p>",
  "finalidade": "aluguel",
  "tipo": "loja",
  "status": "disponivel",
  "destaque": false,
  "endereco": "Rua Fernandes Tourinho, 88",
  "bairro": "Serra",
  "cidade": "Belo Horizonte",
  "cep": "30240-010",
  "area_total": 85,
  "area_util": 75,
  "banheiros": 1,
  "vagas": 0,
  "preco_aluguel": 4500,
  "iptu": 2800,
  "caracteristicas": ["Esquina", "Vitrine ampla", "Mezanino", "Alta visibilidade"]
}'

echo ""
echo "Seed concluído! 10 imóveis cadastrados."
