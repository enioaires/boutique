import { createDirectus, rest, readItems, readItem, readSingleton } from "@directus/sdk";
import type { TipoImovel, Localizacao, Imovel, ImovelFile, DadosContato, DadosGerais } from "./types";

export type { TipoImovel, Localizacao, Imovel, ImovelFile, DadosContato, DadosGerais };

interface Schema {
  imoveis: Imovel[];
  imoveis_files: ImovelFile[];
  tipos_imoveis: TipoImovel[];
  localizacoes: Localizacao[];
  dados_contato: DadosContato;
  dados_gerais: DadosGerais;
}

const DIRECTUS_URL = import.meta.env.PUBLIC_DIRECTUS_URL || "http://localhost:8055";

export const directus = createDirectus<Schema>(DIRECTUS_URL).with(rest());

export { readItems, readItem, readSingleton };
