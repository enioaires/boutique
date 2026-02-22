<script lang="ts">
  import { fly } from "svelte/transition";
  import type { TipoImovel, Localizacao, FilterState } from "../../lib/types";
  import RangeSlider from "./RangeSlider.svelte";
  import PillSelect from "./PillSelect.svelte";

  interface Props {
    tiposImoveis: TipoImovel[];
    localizacoes: Localizacao[];
    filters: FilterState;
    activeFilterCount: number;
    onClear: () => void;
  }

  let { tiposImoveis, localizacoes, filters = $bindable(), activeFilterCount, onClear }: Props = $props();

  let drawerOpen = $state(false);

  const tiposResidencial = $derived(tiposImoveis.filter((t) => t.categoria === "residencial"));
  const tiposComercial = $derived(tiposImoveis.filter((t) => t.categoria === "comercial"));
  const regioes = $derived(() => {
    const map = new Map<string, Localizacao[]>();
    for (const loc of localizacoes) {
      const regiao = loc.regiao || "Outros";
      if (!map.has(regiao)) map.set(regiao, []);
      map.get(regiao)!.push(loc);
    }
    return [...map.entries()];
  });

  const precoDisabled = $derived(filters.finalidade === null);
  const precoMax = $derived(filters.finalidade === "aluguel" ? 20000 : 10000000);
  const precoStep = $derived(filters.finalidade === "aluguel" ? 500 : 50000);

  function formatPreco(v: number): string {
    if (v >= 1000000) return `R$ ${(v / 1000000).toFixed(1).replace(".0", "")}M`;
    if (v >= 1000) return `R$ ${(v / 1000).toFixed(0)}mil`;
    return `R$ ${v}`;
  }

  function formatArea(v: number): string {
    return `${v}m²`;
  }

  const pillOptions = [
    { value: 1, label: "1" },
    { value: 2, label: "2" },
    { value: 3, label: "3" },
    { value: 4, label: "4+" },
  ];

  function toggleFinalidade(val: "compra" | "aluguel") {
    if (filters.finalidade === val) {
      filters.finalidade = null;
    } else {
      filters.finalidade = val;
      filters.precoMin = 0;
      filters.precoMax = val === "aluguel" ? 20000 : 10000000;
    }
  }

  function handleClear() {
    onClear();
    drawerOpen = false;
  }

  const selectClass =
    "w-full h-10 rounded-lg border border-verde-200 bg-white px-3 text-sm text-verde-900 outline-none transition-all duration-150 focus:border-verde-500 focus:ring-2 focus:ring-verde-500/20 hover:border-verde-300";
</script>

<!-- ===== MOBILE: sticky button + drawer ===== -->
<div class="fixed bottom-6 left-1/2 z-40 -translate-x-1/2 md:hidden">
  <button
    type="button"
    class="flex items-center gap-2 rounded-full bg-verde-500 px-6 py-3 text-sm font-medium text-white shadow-lg shadow-verde-500/30 active:scale-95 cursor-pointer"
    onclick={() => (drawerOpen = true)}
  >
    <svg class="size-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 6h9.75M10.5 6a1.5 1.5 0 1 1-3 0m3 0a1.5 1.5 0 1 0-3 0M3.75 6H7.5m3 12h9.75m-9.75 0a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m-3.75 0H7.5m9-6h3.75m-3.75 0a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m-9.75 0h9.75" />
    </svg>
    Filtros
    {#if activeFilterCount > 0}
      <span class="flex size-5 items-center justify-center rounded-full bg-white text-xs font-bold text-verde-500">{activeFilterCount}</span>
    {/if}
  </button>
</div>

{#if drawerOpen}
  <!-- svelte-ignore a11y_no_static_element_interactions -->
  <div
    class="fixed inset-0 z-50 bg-verde-900/40 md:hidden"
    transition:fly={{ duration: 150 }}
    onclick={() => (drawerOpen = false)}
    onkeydown={(e) => e.key === "Escape" && (drawerOpen = false)}
  >
    <!-- svelte-ignore a11y_no_static_element_interactions -->
    <div
      class="absolute inset-x-0 bottom-0 max-h-[85vh] overflow-y-auto rounded-t-2xl bg-white px-5 pb-8 pt-3"
      transition:fly={{ y: "100%", duration: 250 }}
      onclick={(e: MouseEvent) => e.stopPropagation()}
    >
      <div class="mb-4 flex justify-center"><div class="h-1 w-8 rounded-full bg-verde-200"></div></div>

      <div class="mb-4 flex items-center justify-between">
        <p class="text-[15px] font-semibold text-verde-900">Filtros</p>
        <button
          type="button"
          class="rounded-lg p-1 text-verde-400 hover:text-verde-600 cursor-pointer"
          onclick={() => (drawerOpen = false)}
          aria-label="Fechar"
        >
          <svg class="size-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      <div class="space-y-5">
        <!-- Finalidade -->
        <div>
          <p class="mb-1.5 text-xs font-medium text-verde-600">Finalidade</p>
          <div class="flex gap-2">
            <button
              type="button"
              class="flex-1 h-10 rounded-lg border text-sm font-medium transition-all cursor-pointer {filters.finalidade === 'compra' ? 'bg-verde-500 text-white border-verde-500' : 'bg-white text-verde-700 border-verde-200 hover:border-verde-400'}"
              onclick={() => toggleFinalidade("compra")}
            >Compra</button>
            <button
              type="button"
              class="flex-1 h-10 rounded-lg border text-sm font-medium transition-all cursor-pointer {filters.finalidade === 'aluguel' ? 'bg-verde-500 text-white border-verde-500' : 'bg-white text-verde-700 border-verde-200 hover:border-verde-400'}"
              onclick={() => toggleFinalidade("aluguel")}
            >Aluguel</button>
          </div>
        </div>

        <!-- Tipo + Localização -->
        <div class="flex gap-3">
          <div class="flex-1">
            <label for="m-tipo" class="mb-1.5 block text-xs font-medium text-verde-600">Tipo</label>
            <select id="m-tipo" class={selectClass} bind:value={filters.tipo}>
              <option value="">Todos</option>
              <optgroup label="Residencial">{#each tiposResidencial as t}<option value={t.slug}>{t.nome}</option>{/each}</optgroup>
              <optgroup label="Comercial">{#each tiposComercial as t}<option value={t.slug}>{t.nome}</option>{/each}</optgroup>
            </select>
          </div>
          <div class="flex-1">
            <label for="m-loc" class="mb-1.5 block text-xs font-medium text-verde-600">Localização</label>
            <select id="m-loc" class={selectClass} bind:value={filters.localizacao}>
              <option value="">Todas</option>
              {#each regioes() as [regiao, locs]}
                <optgroup label={regiao}>{#each locs as l}<option value={l.slug}>{l.nome}</option>{/each}</optgroup>
              {/each}
            </select>
          </div>
        </div>

        <!-- Preço -->
        <div>
          <RangeSlider label="Preço" id="m-preco" min={0} max={precoMax} step={precoStep} bind:valueLow={filters.precoMin} bind:valueHigh={filters.precoMax} formatLabel={formatPreco} disabled={precoDisabled} />
        </div>

        <!-- Pills grid -->
        <div class="flex gap-4">
          <div class="flex-1"><PillSelect label="Quartos" id="m-quartos" options={pillOptions} bind:selected={filters.quartos} /></div>
          <div class="flex-1"><PillSelect label="Suítes" id="m-suites" options={pillOptions} bind:selected={filters.suites} /></div>
        </div>
        <div class="flex gap-4">
          <div class="flex-1"><PillSelect label="Banheiros" id="m-banheiros" options={pillOptions} bind:selected={filters.banheiros} /></div>
          <div class="flex-1"><PillSelect label="Vagas" id="m-vagas" options={pillOptions} bind:selected={filters.vagas} /></div>
        </div>

        <!-- Área -->
        <div>
          <RangeSlider label="Área" id="m-area" min={0} max={1000} step={10} bind:valueLow={filters.areaMin} bind:valueHigh={filters.areaMax} formatLabel={formatArea} />
        </div>
      </div>

      <div class="mt-6 flex gap-3">
        {#if activeFilterCount > 0}
          <button type="button" class="h-11 rounded-lg border border-verde-200 px-5 text-sm font-medium text-verde-600 hover:bg-verde-50 cursor-pointer" onclick={handleClear}>Limpar</button>
        {/if}
        <button type="button" class="h-11 flex-1 rounded-lg bg-verde-500 text-sm font-medium text-white hover:bg-verde-600 cursor-pointer" onclick={() => (drawerOpen = false)}>Ver resultados</button>
      </div>
    </div>
  </div>
{/if}

<!-- ===== DESKTOP: horizontal filter panel ===== -->
<div class="hidden md:block rounded-2xl bg-verde-50/60 px-6 py-5">
  <!-- Row 1 -->
  <div class="flex items-end gap-4">
    <!-- Finalidade -->
    <div class="w-44 shrink-0">
      <p class="mb-1.5 text-xs font-medium text-verde-600">Finalidade</p>
      <div class="flex gap-1.5">
        <button
          type="button"
          class="flex-1 h-10 rounded-lg border text-sm font-medium transition-all duration-150 cursor-pointer {filters.finalidade === 'compra' ? 'bg-verde-500 text-white border-verde-500 shadow-sm' : 'bg-white text-verde-700 border-verde-200 hover:border-verde-400 hover:bg-verde-50'}"
          onclick={() => toggleFinalidade("compra")}
        >Compra</button>
        <button
          type="button"
          class="flex-1 h-10 rounded-lg border text-sm font-medium transition-all duration-150 cursor-pointer {filters.finalidade === 'aluguel' ? 'bg-verde-500 text-white border-verde-500 shadow-sm' : 'bg-white text-verde-700 border-verde-200 hover:border-verde-400 hover:bg-verde-50'}"
          onclick={() => toggleFinalidade("aluguel")}
        >Aluguel</button>
      </div>
    </div>

    <!-- Tipo -->
    <div class="flex-1 min-w-0">
      <label for="d-tipo" class="mb-1.5 block text-xs font-medium text-verde-600">Tipo de Imóvel</label>
      <select id="d-tipo" class={selectClass} bind:value={filters.tipo}>
        <option value="">Todos</option>
        <optgroup label="Residencial">{#each tiposResidencial as t}<option value={t.slug}>{t.nome}</option>{/each}</optgroup>
        <optgroup label="Comercial">{#each tiposComercial as t}<option value={t.slug}>{t.nome}</option>{/each}</optgroup>
      </select>
    </div>

    <!-- Localização -->
    <div class="flex-1 min-w-0">
      <label for="d-loc" class="mb-1.5 block text-xs font-medium text-verde-600">Localização</label>
      <select id="d-loc" class={selectClass} bind:value={filters.localizacao}>
        <option value="">Todas</option>
        {#each regioes() as [regiao, locs]}
          <optgroup label={regiao}>{#each locs as l}<option value={l.slug}>{l.nome}</option>{/each}</optgroup>
        {/each}
      </select>
    </div>

    <!-- Preço -->
    <div class="w-48 shrink-0">
      <RangeSlider label="Preço" id="d-preco" min={0} max={precoMax} step={precoStep} bind:valueLow={filters.precoMin} bind:valueHigh={filters.precoMax} formatLabel={formatPreco} disabled={precoDisabled} />
    </div>
  </div>

  <!-- Row 2 -->
  <div class="mt-4 flex items-end gap-5">
    <div><PillSelect label="Quartos" id="d-quartos" options={pillOptions} bind:selected={filters.quartos} /></div>
    <div><PillSelect label="Suítes" id="d-suites" options={pillOptions} bind:selected={filters.suites} /></div>
    <div><PillSelect label="Banheiros" id="d-banheiros" options={pillOptions} bind:selected={filters.banheiros} /></div>
    <div><PillSelect label="Vagas" id="d-vagas" options={pillOptions} bind:selected={filters.vagas} /></div>
    <div class="w-48 shrink-0">
      <RangeSlider label="Área" id="d-area" min={0} max={1000} step={10} bind:valueLow={filters.areaMin} bind:valueHigh={filters.areaMax} formatLabel={formatArea} />
    </div>

    {#if activeFilterCount > 0}
      <button
        type="button"
        class="ml-auto shrink-0 self-end text-xs font-medium text-verde-500 underline decoration-verde-300 underline-offset-2 hover:text-verde-700 hover:decoration-verde-500 transition-colors cursor-pointer"
        onclick={handleClear}
      >
        Limpar filtros
      </button>
    {/if}
  </div>
</div>
