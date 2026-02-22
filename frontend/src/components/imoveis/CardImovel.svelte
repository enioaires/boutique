<script lang="ts">
  import type { ImovelPopulado } from "../../lib/types";

  interface Props {
    imovel: ImovelPopulado;
  }

  let { imovel }: Props = $props();

  const DIRECTUS_URL = import.meta.env.PUBLIC_DIRECTUS_URL || "http://localhost:8055";

  function formatPreco(valor: string | null): string {
    if (!valor) return "Sob consulta";
    return Number(valor).toLocaleString("pt-BR", {
      style: "currency",
      currency: "BRL",
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    });
  }

  const preco = $derived(
    imovel.finalidade === "compra" ? formatPreco(imovel.preco_venda) : formatPreco(imovel.preco_aluguel),
  );
</script>

<a
  href="/imoveis/{imovel.slug}"
  class="group overflow-hidden rounded-xl bg-offwhite shadow-sm transition-all duration-300 hover:shadow-lg hover:-translate-y-1"
>
  <!-- Imagem -->
  <div class="relative aspect-4/3 overflow-hidden bg-verde-100">
    {#if imovel.imagem_destaque}
      <img
        src="{DIRECTUS_URL}/assets/{imovel.imagem_destaque}?width=600&height=450&fit=cover"
        alt={imovel.titulo}
        class="size-full object-cover transition-transform duration-500 group-hover:scale-105"
        loading="lazy"
      />
    {:else}
      <div class="flex size-full items-center justify-center">
        <svg class="size-12 text-verde-200" fill="none" stroke="currentColor" stroke-width="1" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="m2.25 15.75 5.159-5.159a2.25 2.25 0 0 1 3.182 0l5.159 5.159m-1.5-1.5 1.409-1.409a2.25 2.25 0 0 1 3.182 0l2.909 2.909M3.75 21h16.5A2.25 2.25 0 0 0 22.5 18.75V5.25A2.25 2.25 0 0 0 20.25 3H3.75A2.25 2.25 0 0 0 1.5 5.25v13.5A2.25 2.25 0 0 0 3.75 21Z"
          />
        </svg>
      </div>
    {/if}

    <!-- Badge status -->
    {#if imovel.status !== "disponivel"}
      <div class="absolute inset-0 flex items-center justify-center bg-verde-900/60">
        <span class="rounded-full bg-white px-4 py-1.5 text-sm font-semibold uppercase tracking-wider text-verde-900">
          {imovel.status === "vendido" ? "Vendido" : imovel.status === "alugado" ? "Alugado" : "Reservado"}
        </span>
      </div>
    {/if}

    <!-- Badges -->
    <div class="absolute top-3 left-3 flex items-center gap-1.5">
      <span class="rounded-full bg-verde-700/80 px-3 py-1 text-xs font-medium text-white backdrop-blur-sm">
        {imovel.finalidade === "compra" ? "Venda" : "Aluguel"}
      </span>
      {#if imovel.codigo}
        <span class="rounded-full bg-white/80 px-2.5 py-1 text-[11px] font-medium text-verde-700 backdrop-blur-sm">
          {imovel.codigo}
        </span>
      {/if}
    </div>
  </div>

  <!-- Info -->
  <div class="p-5">
    <!-- Preço -->
    <p class="text-lg font-semibold text-verde-900">
      {preco}
      {#if imovel.finalidade === "aluguel"}
        <span class="text-xs font-normal text-verde-600">/mês</span>
      {/if}
    </p>

    <!-- Separador -->
    <div class="my-3 h-px bg-verde-100"></div>

    <!-- Título e localização -->
    <h3 class="text-sm font-semibold uppercase tracking-wide text-verde-500">
      {imovel.titulo}
    </h3>
    <p class="mt-0.5 text-xs text-verde-600/70">
      {imovel.localizacao.nome}
    </p>

    <!-- Separador -->
    <div class="my-3 h-px bg-verde-100"></div>

    <!-- Detalhes -->
    <div class="flex items-center justify-between text-verde-700">
      <!-- Tipo -->
      <div class="flex flex-col items-center gap-1">
        <svg class="size-5" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M8.25 21v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21m0 0h4.5V3.545M12.75 21h7.5V10.75M2.25 21h1.5m18 0h-18M2.25 9l4.5-1.636M18.75 3l-1.5.545m0 6.205 3 1m1.5.5-1.5-.5M6.75 7.364V3h-3v18m3-13.636 10.5-3.819"
          />
        </svg>
        <span class="text-[11px]">{imovel.tipo_imovel.nome}</span>
      </div>

      <!-- Quartos -->
      {#if imovel.quartos}
        <div class="flex flex-col items-center gap-1">
          <svg class="size-5" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M2.25 7.125C2.25 6.504 2.754 6 3.375 6h6c.621 0 1.125.504 1.125 1.125v3.75c0 .621-.504 1.125-1.125 1.125h-6a1.125 1.125 0 0 1-1.125-1.125v-3.75ZM14.25 8.625c0-.621.504-1.125 1.125-1.125h5.25c.621 0 1.125.504 1.125 1.125v8.25c0 .621-.504 1.125-1.125 1.125h-5.25a1.125 1.125 0 0 1-1.125-1.125v-8.25ZM3.75 16.125c0-.621.504-1.125 1.125-1.125h5.25c.621 0 1.125.504 1.125 1.125v2.25c0 .621-.504 1.125-1.125 1.125h-5.25a1.125 1.125 0 0 1-1.125-1.125v-2.25Z"
            />
          </svg>
          <span class="text-[11px]">
            {imovel.quartos}
            {imovel.quartos === 1 ? "quarto" : "quartos"}
            {#if imovel.suites}
              <br /><span class="text-verde-500">{imovel.suites} {imovel.suites === 1 ? "suíte" : "suítes"}</span>
            {/if}
          </span>
        </div>
      {/if}

      <!-- Área -->
      {#if imovel.area_total}
        <div class="flex flex-col items-center gap-1">
          <svg class="size-5" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M3.75 3.75v4.5m0-4.5h4.5m-4.5 0L9 9M3.75 20.25v-4.5m0 4.5h4.5m-4.5 0L9 15M20.25 3.75h-4.5m4.5 0v4.5m0-4.5L15 9m5.25 11.25h-4.5m4.5 0v-4.5m0 4.5L15 15"
            />
          </svg>
          <span class="text-[11px]">{imovel.area_total}m²</span>
        </div>
      {/if}

      <!-- Vagas -->
      {#if imovel.vagas}
        <div class="flex flex-col items-center gap-1">
          <svg class="size-5" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 0 0-3.213-9.193 2.056 2.056 0 0 0-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 0 0-10.026 0 1.106 1.106 0 0 0-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12"
            />
          </svg>
          <span class="text-[11px]">{imovel.vagas} {imovel.vagas === 1 ? "vaga" : "vagas"}</span>
        </div>
      {/if}
    </div>
  </div>
</a>
