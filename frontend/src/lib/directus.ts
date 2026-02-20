import { createDirectus, rest, readItems, readItem } from "@directus/sdk";
import type { TipoImovel, Localizacao, Imovel } from "./types";

export type { TipoImovel, Localizacao, Imovel };

interface Schema {
  imoveis: Imovel[];
  tipos_imoveis: TipoImovel[];
  localizacoes: Localizacao[];
}

const DIRECTUS_URL = import.meta.env.PUBLIC_DIRECTUS_URL || "http://localhost:8055";

export const directus = createDirectus<Schema>(DIRECTUS_URL).with(rest());

export { readItems, readItem };
