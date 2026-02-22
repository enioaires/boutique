<script lang="ts">
  import type { DadosContato } from "../lib/types";

  const DIRECTUS_URL = import.meta.env.PUBLIC_DIRECTUS_URL || "http://localhost:8055";

  let contato = $state<DadosContato | null>(null);

  $effect(() => {
    fetch(`${DIRECTUS_URL}/items/dados_contato`)
      .then((r) => r.json())
      .then((r) => (contato = r.data))
      .catch(() => {});
  });
</script>

{#if contato}
  <header class="w-full bg-verde-700 animate-slide-down">
    <div class="mx-auto max-w-7xl px-5 md:px-6">
      <!-- Mobile -->
      <div class="flex items-center justify-between h-14 md:hidden">
        <a href="/" class="text-lg font-light tracking-widest text-white uppercase">
          Urbana<span class="font-bold">Boutique</span>
        </a>
        <div class="flex items-center gap-5">
          <a href="tel:+{contato.telefone_raw}" aria-label="Ligar" class="text-white transition-transform duration-200 hover:scale-110 active:scale-95">
            <svg class="size-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 0 0 2.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 0 1-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 0 0-1.091-.852H4.5A2.25 2.25 0 0 0 2.25 4.5v2.25Z" /></svg>
          </a>
          <a href="https://wa.me/{contato.whatsapp}" aria-label="WhatsApp" class="text-white transition-transform duration-200 hover:scale-110 active:scale-95">
            <svg class="size-5" fill="currentColor" viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413Z" /></svg>
          </a>
          <a href="mailto:{contato.email}" aria-label="Email" class="text-white transition-transform duration-200 hover:scale-110 active:scale-95">
            <svg class="size-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" /></svg>
          </a>
        </div>
      </div>

      <!-- Desktop -->
      <div class="hidden md:flex items-center justify-between h-20">
        <a href="/" class="text-2xl font-light tracking-widest text-white uppercase transition-opacity duration-200 hover:opacity-80">
          Urbana<span class="font-bold">Boutique</span>
        </a>

        <div class="flex items-center gap-10">
          <a href="tel:+{contato.telefone_raw}" class="group flex items-center gap-2.5 text-white transition-transform duration-200 hover:-translate-y-0.5">
            <svg class="size-5 transition-transform duration-200 group-hover:scale-110" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 0 0 2.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 0 1-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 0 0-1.091-.852H4.5A2.25 2.25 0 0 0 2.25 4.5v2.25Z" /></svg>
            <div>
              <p class="text-xs text-white/70 leading-tight">Ligue agora</p>
              <p class="text-sm font-medium leading-tight">{contato.telefone}</p>
            </div>
          </a>

          <a
            href="https://wa.me/{contato.whatsapp}"
            class="group flex items-center gap-2.5 text-white transition-transform duration-200 hover:-translate-y-0.5"
          >
            <svg class="size-5 transition-transform duration-200 group-hover:scale-110" fill="currentColor" viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413Z" /></svg>
            <div>
              <p class="text-xs text-white/70 leading-tight">Atendimento</p>
              <p class="text-sm font-medium leading-tight">WhatsApp</p>
            </div>
          </a>

          <a
            href="mailto:{contato.email}"
            class="group flex items-center gap-2.5 text-white transition-transform duration-200 hover:-translate-y-0.5"
          >
            <svg class="size-5 transition-transform duration-200 group-hover:scale-110" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" /></svg>
            <div>
              <p class="text-xs text-white/70 leading-tight">Atendimento</p>
              <p class="text-sm font-medium leading-tight">Email</p>
            </div>
          </a>
        </div>

        <div class="flex items-center gap-4">
          {#if contato.facebook_url}
            <a href={contato.facebook_url} target="_blank" rel="noopener" aria-label="Facebook" class="text-white transition-transform duration-200 hover:scale-110 hover:-translate-y-0.5">
              <svg class="size-5" fill="currentColor" viewBox="0 0 24 24"><path d="M9.101 23.691v-7.98H6.627v-3.667h2.474v-1.58c0-4.085 1.848-5.978 5.858-5.978.401 0 1.09.07 1.373.14v3.34c-.149-.017-.408-.024-.732-.024-1.038 0-1.44.395-1.44 1.42v2.682h3.522l-.605 3.667h-2.917v8.196C18.996 22.92 24 17.67 24 12.297 24 6.174 18.627.6 12 .6S0 6.174 0 12.297c0 5.043 3.438 9.272 8.088 10.512l1.013.882Z" /></svg>
            </a>
          {/if}
          {#if contato.instagram_url}
            <a href={contato.instagram_url} target="_blank" rel="noopener" aria-label="Instagram" class="text-white transition-transform duration-200 hover:scale-110 hover:-translate-y-0.5">
              <svg class="size-5" fill="currentColor" viewBox="0 0 24 24"><path d="M7.0301.084c-1.2768.0602-2.1487.264-2.911.5634-.7888.3075-1.4575.72-2.1228 1.3877-.6652.6677-1.075 1.3368-1.3802 2.127-.2954.7638-.4956 1.6365-.552 2.914-.0564 1.2775-.0689 1.6882-.0626 4.947.0062 3.2586.0206 3.6671.0825 4.9473.061 1.2765.264 2.1482.5635 2.9107.308.7889.72 1.4573 1.388 2.1228.6679.6655 1.3365 1.0743 2.1285 1.38.7632.295 1.6361.4961 2.9134.552 1.2773.056 1.6884.069 4.9462.0627 3.2578-.0062 3.668-.0207 4.9478-.0814 1.28-.0607 2.147-.2652 2.9098-.5633.7889-.3086 1.4578-.72 2.1228-1.3881.665-.6682 1.0745-1.3378 1.3795-2.1284.2957-.7632.4966-1.636.552-2.9124.056-1.2809.0692-1.6898.063-4.948-.0063-3.2583-.021-3.6668-.0817-4.9465-.0607-1.2797-.264-2.1487-.5633-2.9117-.3084-.7889-.72-1.4568-1.3876-2.1228C21.2982 1.33 20.628.9208 19.8504.6166 19.0872.321 18.2143.12 16.9366.0635 15.6588.0075 15.2479-.0048 11.9999-.0048c-3.2474 0-3.6677.0189-4.9699.0837ZM7.114 2.225c1.2573-.0574 1.6345-.0689 4.8478-.0626 3.2141.006 3.5828.0189 4.8428.0787 1.1643.054 1.7963.2503 2.217.4156.5573.2165.9555.4755 1.3742.8945.4182.4194.6766.8179.8936 1.3758.1644.4206.3611 1.0536.4142 2.2172.06 1.2642.074 1.6321.068 4.8487-.006 3.2163-.02 3.5855-.079 4.8465-.054 1.1637-.251 1.7957-.415 2.2162-.2165.558-.4762.9567-.895 1.3743-.4195.4182-.8183.6773-1.3758.8943-.4211.1645-1.0537.3616-2.2173.4154-1.2634.059-1.632.073-4.847.067-3.2154-.006-3.5856-.0197-4.8487-.0795-1.1636-.054-1.7952-.2516-2.2166-.4155-.5578-.2163-.9578-.4759-1.3747-.8948-.4181-.4187-.6767-.8164-.8937-1.3744-.1647-.4213-.3612-1.0542-.4155-2.2177-.0595-1.2637-.0733-1.6322-.0672-4.8476.0062-3.2163.0193-3.5858.0789-4.8478.054-1.1644.2505-1.7964.4158-2.2169.2168-.5581.4757-.9565.8946-1.375.4185-.4183.8178-.6768 1.3755-.8943.4217-.1648 1.0534-.3617 2.2168-.4156Zm9.5616 1.986a1.44 1.44 0 1 0 0 2.8794 1.44 1.44 0 0 0 0-2.8793ZM5.8385 12.012c.0067 3.4032 2.7706 6.1557 6.173 6.1493 3.4026-.0065 6.157-2.7701 6.1506-6.1733-.0065-3.4032-2.771-6.1565-6.174-6.1498-3.403.0067-6.156 2.771-6.1496 6.1738ZM8 12.0077a4 4 0 1 1 8.0083.0066A4 4 0 0 1 8 12.0077Z" /></svg>
            </a>
          {/if}
          {#if contato.youtube_url}
            <a href={contato.youtube_url} target="_blank" rel="noopener" aria-label="YouTube" class="text-white transition-transform duration-200 hover:scale-110 hover:-translate-y-0.5">
              <svg class="size-5" fill="currentColor" viewBox="0 0 24 24"><path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814ZM9.545 15.568V8.432L15.818 12l-6.273 3.568Z" /></svg>
            </a>
          {/if}
        </div>
      </div>
    </div>
  </header>
{:else}
  <!-- Skeleton enquanto carrega -->
  <header class="w-full bg-verde-700">
    <div class="mx-auto max-w-7xl px-5 md:px-6">
      <div class="flex items-center justify-between h-14 md:h-20">
        <a href="/" class="text-lg md:text-2xl font-light tracking-widest text-white uppercase">
          Urbana<span class="font-bold">Boutique</span>
        </a>
        <div class="flex items-center gap-5">
          <div class="size-5 rounded bg-white/20 animate-pulse"></div>
          <div class="size-5 rounded bg-white/20 animate-pulse"></div>
          <div class="size-5 rounded bg-white/20 animate-pulse"></div>
        </div>
      </div>
    </div>
  </header>
{/if}
