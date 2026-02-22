<script lang="ts">
  import EmblaCarousel from "embla-carousel";
  import type { EmblaCarouselType } from "embla-carousel";

  interface Props {
    images: string[];
    alt: string;
    directusUrl: string;
  }

  let { images, alt, directusUrl }: Props = $props();

  let viewport: HTMLDivElement;
  let embla: EmblaCarouselType | undefined;
  let selectedIndex = $state(0);
  let canScrollPrev = $state(false);
  let canScrollNext = $state(false);

  function onSelect() {
    if (!embla) return;
    selectedIndex = embla.selectedScrollSnap();
    canScrollPrev = embla.canScrollPrev();
    canScrollNext = embla.canScrollNext();
  }

  $effect(() => {
    if (!viewport) return;
    embla = EmblaCarousel(viewport, { loop: true });
    embla.on("select", onSelect);
    embla.on("init", onSelect);
    return () => embla?.destroy();
  });
</script>

<div class="relative overflow-hidden rounded-xl bg-verde-100">
  <!-- Viewport -->
  <div bind:this={viewport} class="overflow-hidden">
    <div class="flex">
      {#each images as imageId, i}
        <div class="min-w-0 flex-[0_0_100%]">
          <div class="aspect-2/1 md:aspect-[16/7]">
            <img
              src="{directusUrl}/assets/{imageId}?width=1400&height=700&fit=cover"
              alt="{alt} - Foto {i + 1}"
              class="size-full object-cover"
              loading={i === 0 ? "eager" : "lazy"}
            />
          </div>
        </div>
      {/each}
    </div>
  </div>

  <!-- Prev/Next arrows -->
  {#if images.length > 1}
    <button
      type="button"
      class="absolute left-3 top-1/2 -translate-y-1/2 flex size-10 items-center justify-center rounded-full bg-white/80 text-verde-900 backdrop-blur-sm transition-all hover:bg-white disabled:opacity-30 cursor-pointer"
      disabled={!canScrollPrev}
      onclick={() => embla?.scrollPrev()}
      aria-label="Foto anterior"
    >
      <svg class="size-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5 8.25 12l7.5-7.5" />
      </svg>
    </button>
    <button
      type="button"
      class="absolute right-3 top-1/2 -translate-y-1/2 flex size-10 items-center justify-center rounded-full bg-white/80 text-verde-900 backdrop-blur-sm transition-all hover:bg-white disabled:opacity-30 cursor-pointer"
      disabled={!canScrollNext}
      onclick={() => embla?.scrollNext()}
      aria-label="Foto seguinte"
    >
      <svg class="size-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
      </svg>
    </button>

    <!-- Dots -->
    <div class="absolute bottom-3 left-1/2 -translate-x-1/2 flex gap-1.5">
      {#each images as _, i}
        <button
          type="button"
          class="size-2 rounded-full transition-all cursor-pointer {i === selectedIndex
            ? 'bg-white scale-125'
            : 'bg-white/50 hover:bg-white/75'}"
          onclick={() => embla?.scrollTo(i)}
          aria-label="Ir para foto {i + 1}"
        ></button>
      {/each}
    </div>

    <!-- Counter -->
    <div class="absolute top-3 right-3 rounded-full bg-black/40 px-3 py-1 text-xs text-white backdrop-blur-sm">
      {selectedIndex + 1} / {images.length}
    </div>
  {/if}
</div>
