export interface TipoImovel {
  id: number;
  nome: string;
  slug: string;
  categoria: "residencial" | "comercial";
  sort: number;
}

export interface Localizacao {
  id: number;
  nome: string;
  slug: string;
  regiao: "belo-horizonte" | "grande-bh";
  sort: number;
}

export interface Imovel {
  id: number;
  titulo: string;
  slug: string;
  descricao: string;
  finalidade: "compra" | "aluguel";
  tipo_imovel: number | TipoImovel;
  localizacao: number | Localizacao;
  status: "disponivel" | "vendido" | "alugado" | "reservado";
  destaque: boolean;
  endereco: string;
  cep: string;
  latitude: number | null;
  longitude: number | null;
  area_total: number | null;
  area_util: number | null;
  quartos: number | null;
  suites: number | null;
  banheiros: number | null;
  vagas: number | null;
  andar: number | null;
  preco_venda: string | null;
  preco_aluguel: string | null;
  condominio: string | null;
  iptu: string | null;
  imagem_destaque: string | null;
  video_url: string | null;
  caracteristicas: string[] | null;
  date_created: string;
  date_updated: string;
}
