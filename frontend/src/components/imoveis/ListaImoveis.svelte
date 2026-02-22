<script lang="ts">
  import { fade } from "svelte/transition";
  import type { TipoImovel, Localizacao, ImovelPopulado, FilterState } from "../../lib/types";
  import FiltrosImoveis from "./FiltrosImoveis.svelte";
  import CardImovel from "./CardImovel.svelte";
  import PaginacaoImoveis from "./PaginacaoImoveis.svelte";

  interface Props {
    tiposImoveis: TipoImovel[];
    localizacoes: Localizacao[];
  }

  let { tiposImoveis, localizacoes }: Props = $props();

  const DIRECTUS_URL = import.meta.env.PUBLIC_DIRECTUS_URL || "http://localhost:8055";
  const PER_PAGE = 12;

  function defaultFilters(): FilterState {
    return {
      finalidade: null,
      tipo: "",
      localizacao: "",
      precoMin: 0,
      precoMax: 10000000,
      quartos: null,
      suites: null,
      banheiros: null,
      vagas: null,
      areaMin: 0,
      areaMax: 1000,
    };
  }

  let filters = $state<FilterState>(defaultFilters());
  let page = $state(1);
  let imoveis = $state<ImovelPopulado[]>([]);
  let totalItems = $state(0);
  let loading = $state(true);
  let showSkeleton = $state(true);
  let hasResults = $state(false);
  let skeletonTimer: ReturnType<typeof setTimeout>;
  let error = $state<string | null>(null);

  const totalPages = $derived(Math.max(1, Math.ceil(totalItems / PER_PAGE)));

  const activeFilterCount = $derived.by(() => {
    const d = defaultFilters();
    let count = 0;
    if (filters.finalidade !== null) count++;
    if (filters.tipo !== "") count++;
    if (filters.localizacao !== "") count++;
    if (filters.quartos !== null) count++;
    if (filters.suites !== null) count++;
    if (filters.banheiros !== null) count++;
    if (filters.vagas !== null) count++;
    if (filters.precoMin !== d.precoMin || filters.precoMax !== d.precoMax) {
      if (filters.finalidade !== null) count++;
    }
    if (filters.areaMin !== 0 || filters.areaMax !== 1000) count++;
    return count;
  });

  // Read URL params on mount
  $effect(() => {
    const params = new URLSearchParams(window.location.search);
    const f = defaultFilters();

    const finalidade = params.get("finalidade");
    if (finalidade === "compra" || finalidade === "aluguel") {
      f.finalidade = finalidade;
      f.precoMax = finalidade === "aluguel" ? 20000 : 10000000;
    }
    if (params.get("tipo")) f.tipo = params.get("tipo")!;
    if (params.get("localizacao")) f.localizacao = params.get("localizacao")!;
    if (params.get("precoMin")) f.precoMin = Number(params.get("precoMin"));
    if (params.get("precoMax")) f.precoMax = Number(params.get("precoMax"));
    if (params.get("quartos")) f.quartos = Number(params.get("quartos"));
    if (params.get("suites")) f.suites = Number(params.get("suites"));
    if (params.get("banheiros")) f.banheiros = Number(params.get("banheiros"));
    if (params.get("vagas")) f.vagas = Number(params.get("vagas"));
    if (params.get("areaMin")) f.areaMin = Number(params.get("areaMin"));
    if (params.get("areaMax")) f.areaMax = Number(params.get("areaMax"));
    if (params.get("pagina")) page = Number(params.get("pagina"));

    filters = f;

    // This effect runs only once — untrack the subsequent reactive effect
    return;
  });

  // Build query string for Directus
  function buildQuery(): string {
    const params = new URLSearchParams();

    params.set("fields", "*,tipo_imovel.*,localizacao.*");
    params.set("filter[status][_eq]", "disponivel");
    params.set("sort", "-date_created");
    params.set("limit", String(PER_PAGE));
    params.set("offset", String((page - 1) * PER_PAGE));
    params.set("meta", "filter_count");

    if (filters.finalidade) {
      params.set("filter[finalidade][_eq]", filters.finalidade);
    }
    if (filters.tipo) {
      params.set("filter[tipo_imovel][slug][_eq]", filters.tipo);
    }
    if (filters.localizacao) {
      params.set("filter[localizacao][slug][_eq]", filters.localizacao);
    }

    // Price filter
    if (filters.finalidade) {
      const field = filters.finalidade === "compra" ? "preco_venda" : "preco_aluguel";
      const maxDefault = filters.finalidade === "aluguel" ? 20000 : 10000000;
      if (filters.precoMin > 0) {
        params.set(`filter[${field}][_gte]`, String(filters.precoMin));
      }
      if (filters.precoMax < maxDefault) {
        params.set(`filter[${field}][_lte]`, String(filters.precoMax));
      }
    }

    // Numeric filters: quartos, suites, banheiros, vagas
    for (const key of ["quartos", "suites", "banheiros", "vagas"] as const) {
      const val = filters[key];
      if (val !== null) {
        if (val === 4) {
          params.set(`filter[${key}][_gte]`, "4");
        } else {
          params.set(`filter[${key}][_eq]`, String(val));
        }
      }
    }

    // Area
    if (filters.areaMin > 0) {
      params.set("filter[area_total][_gte]", String(filters.areaMin));
    }
    if (filters.areaMax < 1000) {
      params.set("filter[area_total][_lte]", String(filters.areaMax));
    }

    return params.toString();
  }

  // Sync filters to URL
  function syncURL() {
    const params = new URLSearchParams();
    if (filters.finalidade) params.set("finalidade", filters.finalidade);
    if (filters.tipo) params.set("tipo", filters.tipo);
    if (filters.localizacao) params.set("localizacao", filters.localizacao);
    if (filters.finalidade) {
      const maxDefault = filters.finalidade === "aluguel" ? 20000 : 10000000;
      if (filters.precoMin > 0) params.set("precoMin", String(filters.precoMin));
      if (filters.precoMax < maxDefault) params.set("precoMax", String(filters.precoMax));
    }
    if (filters.quartos !== null) params.set("quartos", String(filters.quartos));
    if (filters.suites !== null) params.set("suites", String(filters.suites));
    if (filters.banheiros !== null) params.set("banheiros", String(filters.banheiros));
    if (filters.vagas !== null) params.set("vagas", String(filters.vagas));
    if (filters.areaMin > 0) params.set("areaMin", String(filters.areaMin));
    if (filters.areaMax < 1000) params.set("areaMax", String(filters.areaMax));
    if (page > 1) params.set("pagina", String(page));

    const qs = params.toString();
    const url = qs ? `${window.location.pathname}?${qs}` : window.location.pathname;
    history.replaceState(null, "", url);
  }

  // Fetch data with debounce
  let debounceTimer: ReturnType<typeof setTimeout>;
  let fetchKey = $derived(JSON.stringify(filters) + "|" + page);
  let initialized = $state(false);

  // Mark initialized after first effect runs
  $effect(() => {
    // Read filters to subscribe
    void filters.finalidade;
    if (!initialized) {
      initialized = true;
    }
  });

  $effect(() => {
    // Subscribe to fetchKey
    void fetchKey;

    if (!initialized) return;

    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      fetchImoveis();
      syncURL();
    }, 300);

    return () => clearTimeout(debounceTimer);
  });

  async function fetchImoveis() {
    loading = true;
    error = null;

    // First load: skeleton already visible. Subsequent loads: delay 150ms
    // so fast responses skip the skeleton entirely (no flicker)
    clearTimeout(skeletonTimer);
    if (hasResults) {
      showSkeleton = false;
      skeletonTimer = setTimeout(() => {
        if (loading) showSkeleton = true;
      }, 150);
    }

    try {
      const res = await fetch(`${DIRECTUS_URL}/items/imoveis?${buildQuery()}`);
      if (!res.ok) throw new Error("Erro ao buscar imóveis");
      const json = await res.json();
      imoveis = json.data ?? [];
      totalItems = json.meta?.filter_count ?? 0;
      hasResults = true;
    } catch (e) {
      error = e instanceof Error ? e.message : "Erro desconhecido";
      imoveis = [];
      totalItems = 0;
    } finally {
      loading = false;
      clearTimeout(skeletonTimer);
      showSkeleton = false;
    }
  }

  function clearFilters() {
    filters = defaultFilters();
    page = 1;
  }

  function onPageChange(p: number) {
    page = p;
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

  // Reset page to 1 when filters change (but not on initial load)
  let prevFilterKey = $state("");
  $effect(() => {
    const key = JSON.stringify(filters);
    if (prevFilterKey && prevFilterKey !== key) {
      page = 1;
    }
    prevFilterKey = key;
  });
</script>

<div class="space-y-8">
  <!-- Filters (horizontal on desktop, drawer on mobile) -->
  <FiltrosImoveis {tiposImoveis} {localizacoes} bind:filters {activeFilterCount} onClear={clearFilters} />

  <!-- Main content -->
  <div>
    <!-- Result count -->
    <div class="mb-6 flex items-center justify-between">
      <p class="text-sm text-verde-600 transition-opacity duration-200 {loading && !showSkeleton ? 'opacity-50' : ''}">
        {#if showSkeleton}
          Buscando imóveis...
        {:else if totalItems === 0 && !loading}
          Nenhum imóvel encontrado
        {:else}
          {totalItems} {totalItems === 1 ? "imóvel encontrado" : "imóveis encontrados"}
        {/if}
      </p>
    </div>

    <!-- Loading skeletons (first load, or slow subsequent loads after 150ms) -->
    {#if showSkeleton}
      <div class="grid gap-6 sm:grid-cols-2 md:grid-cols-3" in:fade={{ duration: 150 }}>
        {#each Array(6) as _}
          <div class="overflow-hidden rounded-xl bg-offwhite shadow-sm">
            <div class="aspect-4/3 animate-pulse bg-verde-100"></div>
            <div class="space-y-3 p-5">
              <div class="h-5 w-2/3 animate-pulse rounded bg-verde-100"></div>
              <div class="h-px bg-verde-100"></div>
              <div class="h-4 w-1/2 animate-pulse rounded bg-verde-100"></div>
              <div class="h-3 w-1/3 animate-pulse rounded bg-verde-100"></div>
              <div class="h-px bg-verde-100"></div>
              <div class="flex justify-between">
                <div class="h-8 w-12 animate-pulse rounded bg-verde-100"></div>
                <div class="h-8 w-12 animate-pulse rounded bg-verde-100"></div>
                <div class="h-8 w-12 animate-pulse rounded bg-verde-100"></div>
                <div class="h-8 w-12 animate-pulse rounded bg-verde-100"></div>
              </div>
            </div>
          </div>
        {/each}
      </div>

      <!-- Error state -->
    {:else if error}
      <div class="flex flex-col items-center justify-center rounded-xl bg-verde-50 py-16" in:fade={{ duration: 200 }}>
        <svg class="size-12 text-verde-200" fill="none" stroke="currentColor" stroke-width="1" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z"
          />
        </svg>
        <p class="mt-4 text-sm text-verde-600">{error}</p>
        <button
          type="button"
          class="mt-4 rounded-md bg-verde-500 px-4 py-2 text-sm font-medium text-white hover:bg-verde-600 transition-colors cursor-pointer"
          onclick={fetchImoveis}
        >
          Tentar novamente
        </button>
      </div>

      <!-- Empty state -->
    {:else if imoveis.length === 0 && !loading}
      <div class="flex flex-col items-center justify-center rounded-xl bg-verde-50 py-16" in:fade={{ duration: 200 }}>
        <svg class="size-12 text-verde-200" fill="none" stroke="currentColor" stroke-width="1" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M8.25 21v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21m0 0h4.5V3.545M12.75 21h7.5V10.75M2.25 21h1.5m18 0h-18M2.25 9l4.5-1.636M18.75 3l-1.5.545m0 6.205 3 1m1.5.5-1.5-.5M6.75 7.364V3h-3v18m3-13.636 10.5-3.819"
          />
        </svg>
        <p class="mt-4 text-sm text-verde-400">Nenhum imóvel encontrado com os filtros selecionados.</p>
        {#if activeFilterCount > 0}
          <button
            type="button"
            class="mt-4 text-sm text-verde-500 hover:text-verde-700 transition-colors cursor-pointer"
            onclick={clearFilters}
          >
            Limpar filtros
          </button>
        {/if}
      </div>

      <!-- Results grid: stays visible during fast subsequent loads (with reduced opacity) -->
    {:else if imoveis.length > 0}
      <div
        class="grid gap-6 sm:grid-cols-2 md:grid-cols-3 transition-opacity duration-200 {loading ? 'opacity-50' : ''}"
        in:fade={{ duration: 200 }}
      >
        {#each imoveis as imovel (imovel.id)}
          <CardImovel {imovel} />
        {/each}
      </div>

      <!-- Pagination -->
      <div class="mt-10 transition-opacity duration-200 {loading ? 'opacity-50' : ''}">
        <PaginacaoImoveis {page} {totalPages} {onPageChange} />
      </div>
    {/if}
  </div>
</div>
