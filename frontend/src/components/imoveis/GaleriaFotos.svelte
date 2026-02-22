<script lang="ts">
  interface Props {
    images: string[];
    alt: string;
    directusUrl: string;
  }

  let { images, alt, directusUrl }: Props = $props();

  let lightboxOpen = $state(false);
  let lightboxIndex = $state(0);

  function openLightbox(index: number) {
    lightboxIndex = index;
    lightboxOpen = true;
  }

  function closeLightbox() {
    lightboxOpen = false;
  }

  function prev() {
    lightboxIndex = (lightboxIndex - 1 + images.length) % images.length;
  }

  function next() {
    lightboxIndex = (lightboxIndex + 1) % images.length;
  }

  function handleKeydown(e: KeyboardEvent) {
    if (!lightboxOpen) return;
    if (e.key === "Escape") closeLightbox();
    else if (e.key === "ArrowLeft") prev();
    else if (e.key === "ArrowRight") next();
  }

  // Body scroll lock
  $effect(() => {
    if (lightboxOpen) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    return () => {
      document.body.style.overflow = "";
    };
  });
</script>

<svelte:window onkeydown={handleKeydown} />

{#if images.length > 0}
  <section>
    <h2 class="mb-6 text-xl font-light text-verde-900 md:text-2xl">
      Galeria de <span class="font-semibold text-verde-500">Fotos</span>
    </h2>

    <div class="grid grid-cols-2 gap-2 md:grid-cols-3 md:gap-3">
      {#each images as imageId, i}
        <button
          type="button"
          class="group relative aspect-4/3 overflow-hidden rounded-lg bg-verde-100 cursor-pointer"
          onclick={() => openLightbox(i)}
        >
          <img
            src="{directusUrl}/assets/{imageId}?width=500&height=375&fit=cover"
            alt="{alt} - Foto {i + 1}"
            class="size-full object-cover transition-transform duration-300 group-hover:scale-105"
            loading="lazy"
          />
          <div class="absolute inset-0 bg-black/0 transition-colors duration-300 group-hover:bg-black/10"></div>
        </button>
      {/each}
    </div>
  </section>
{/if}

<!-- Lightbox -->
{#if lightboxOpen}
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/90" role="dialog" aria-modal="true">
    <!-- Backdrop click -->
    <button
      type="button"
      class="absolute inset-0 cursor-default"
      onclick={closeLightbox}
      aria-label="Fechar galeria"
    ></button>

    <!-- Close button -->
    <button
      type="button"
      class="absolute top-4 right-4 z-10 flex size-10 items-center justify-center rounded-full bg-white/10 text-white transition-colors hover:bg-white/20 cursor-pointer"
      onclick={closeLightbox}
      aria-label="Fechar"
    >
      <svg class="size-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
      </svg>
    </button>

    <!-- Counter -->
    <div class="absolute top-4 left-4 z-10 text-sm text-white/70">
      {lightboxIndex + 1} / {images.length}
    </div>

    <!-- Image -->
    <div class="relative z-10 flex max-h-[85vh] max-w-[90vw] items-center justify-center">
      <img
        src="{directusUrl}/assets/{images[lightboxIndex]}?width=1600&height=1100&fit=contain"
        alt="{alt} - Foto {lightboxIndex + 1}"
        class="max-h-[85vh] max-w-[90vw] object-contain"
      />
    </div>

    <!-- Prev -->
    {#if images.length > 1}
      <button
        type="button"
        class="absolute left-3 top-1/2 z-10 -translate-y-1/2 flex size-12 items-center justify-center rounded-full bg-white/10 text-white transition-colors hover:bg-white/20 cursor-pointer"
        onclick={(e) => { e.stopPropagation(); prev(); }}
        aria-label="Foto anterior"
      >
        <svg class="size-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5 8.25 12l7.5-7.5" />
        </svg>
      </button>

      <!-- Next -->
      <button
        type="button"
        class="absolute right-3 top-1/2 z-10 -translate-y-1/2 flex size-12 items-center justify-center rounded-full bg-white/10 text-white transition-colors hover:bg-white/20 cursor-pointer"
        onclick={(e) => { e.stopPropagation(); next(); }}
        aria-label="Foto seguinte"
      >
        <svg class="size-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
        </svg>
      </button>
    {/if}
  </div>
{/if}
