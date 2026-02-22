<script lang="ts">
  interface Props {
    page: number;
    totalPages: number;
    onPageChange: (page: number) => void;
  }

  let { page, totalPages, onPageChange }: Props = $props();

  const WINDOW_SIZE = 2;

  const pages = $derived.by(() => {
    const result: (number | "...")[] = [];
    if (totalPages <= 1) return result;

    const start = Math.max(2, page - WINDOW_SIZE);
    const end = Math.min(totalPages - 1, page + WINDOW_SIZE);

    result.push(1);
    if (start > 2) result.push("...");
    for (let i = start; i <= end; i++) result.push(i);
    if (end < totalPages - 1) result.push("...");
    if (totalPages > 1) result.push(totalPages);

    return result;
  });

  function go(p: number) {
    if (p >= 1 && p <= totalPages && p !== page) {
      onPageChange(p);
    }
  }
</script>

{#if totalPages > 1}
  <nav aria-label="Paginação" class="flex items-center justify-center gap-1">
    <!-- Prev -->
    <button
      type="button"
      class="flex items-center gap-1 rounded-md px-3 py-2 text-sm font-medium transition-colors duration-200 cursor-pointer {page === 1
        ? 'text-verde-300 cursor-not-allowed'
        : 'text-verde-700 hover:bg-verde-100'}"
      disabled={page === 1}
      onclick={() => go(page - 1)}
      aria-label="Página anterior"
    >
      <svg class="size-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5 8.25 12l7.5-7.5" />
      </svg>
      <span class="hidden sm:inline">Anterior</span>
    </button>

    <!-- Page numbers (hidden on very small screens, show current only) -->
    <span class="text-sm text-verde-600 sm:hidden">
      {page} de {totalPages}
    </span>

    <div class="hidden sm:flex items-center gap-1">
      {#each pages as p}
        {#if p === "..."}
          <span class="px-2 py-2 text-sm text-verde-400">...</span>
        {:else}
          <button
            type="button"
            class="min-w-[36px] rounded-md px-3 py-2 text-sm font-medium transition-colors duration-200 cursor-pointer {p === page
              ? 'bg-verde-500 text-white shadow-sm'
              : 'text-verde-700 hover:bg-verde-100'}"
            onclick={() => go(p)}
            aria-label="Página {p}"
            aria-current={p === page ? "page" : undefined}
          >
            {p}
          </button>
        {/if}
      {/each}
    </div>

    <!-- Next -->
    <button
      type="button"
      class="flex items-center gap-1 rounded-md px-3 py-2 text-sm font-medium transition-colors duration-200 cursor-pointer {page === totalPages
        ? 'text-verde-300 cursor-not-allowed'
        : 'text-verde-700 hover:bg-verde-100'}"
      disabled={page === totalPages}
      onclick={() => go(page + 1)}
      aria-label="Próxima página"
    >
      <span class="hidden sm:inline">Próxima</span>
      <svg class="size-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
      </svg>
    </button>
  </nav>
{/if}
