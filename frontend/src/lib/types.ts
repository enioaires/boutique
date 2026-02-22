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

export interface DadosGerais {
  id: number;
  imagem_hero: string | null;
}

export interface DadosContato {
  id: number;
  telefone: string;
  telefone_raw: string;
  whatsapp: string;
  email: string;
  facebook_url: string;
  instagram_url: string;
  youtube_url: string;
}

export interface ImovelFile {
  id: number;
  directus_files_id: string;
  sort: number;
}

export interface Imovel {
  id: number;
  titulo: string;
  slug: string;
  codigo: string | null;
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
  galeria: ImovelFile[] | null;
  date_created: string;
  date_updated: string;
}

export type ImovelPopulado = Imovel & {
  tipo_imovel: TipoImovel;
  localizacao: Localizacao;
  galeria: ImovelFile[];
};

export interface FilterState {
  finalidade: "compra" | "aluguel" | null;
  tipo: string;
  localizacao: string;
  precoMin: number;
  precoMax: number;
  quartos: number | null;
  suites: number | null;
  banheiros: number | null;
  vagas: number | null;
  areaMin: number;
  areaMax: number;
}

export interface PaginationState {
  page: number;
  totalPages: number;
  totalItems: number;
}
