<script lang="ts">
  import { fade, fly } from "svelte/transition";
  import type { TipoImovel, Localizacao } from "../lib/types";

  interface Props {
    tiposImoveis: TipoImovel[];
    localizacoes: Localizacao[];
    heroImage?: string | null;
  }

  let { tiposImoveis, localizacoes, heroImage }: Props = $props();

  let mode = $state<"search" | "code">("search");

  const tiposResidencial = $derived(tiposImoveis.filter((t) => t.categoria === "residencial"));
  const tiposComercial = $derived(tiposImoveis.filter((t) => t.categoria === "comercial"));
  const locBH = $derived(localizacoes.filter((l) => l.regiao === "belo-horizonte"));
  const locGrandeBH = $derived(localizacoes.filter((l) => l.regiao === "grande-bh"));
</script>

<section class="bg-verde-50">
  <div class="mx-auto max-w-7xl px-5 py-10 md:grid md:grid-cols-2 md:items-center md:gap-12 md:px-6 md:py-16">
    <!-- Formulário -->
    <div>
      <h1 class="animate-fade-in-up text-2xl font-light text-verde-900 italic md:text-4xl">
        Encontre o <span class="text-verde-500 not-italic font-normal">imóvel perfeito</span>
        <br />para a sua família
      </h1>

      {#if mode === "search"}
        <form
          action="/imoveis"
          method="get"
          class="mt-8 space-y-5"
          in:fly={{ y: 20, duration: 400, delay: 100 }}
          out:fade={{ duration: 200 }}
        >
          <div class="animate-fade-in-up [animation-delay:100ms]">
            <label for="finalidade" class="block text-sm font-medium text-verde-800 mb-1.5"> Finalidade </label>
            <select
              id="finalidade"
              name="finalidade"
              class="w-full rounded-md border border-verde-200 bg-white px-4 py-3 text-sm text-verde-900 outline-none transition-all duration-200 focus:border-verde-500 focus:ring-2 focus:ring-verde-500/20 hover:border-verde-300"
            >
              <option value="" disabled selected>Compra ou Aluguel</option>
              <option value="compra">Compra</option>
              <option value="aluguel">Aluguel</option>
            </select>
          </div>

          <div class="animate-fade-in-up [animation-delay:200ms]">
            <label for="tipo" class="block text-sm font-medium text-verde-800 mb-1.5"> Tipo de Imóvel </label>
            <select
              id="tipo"
              name="tipo"
              class="w-full rounded-md border border-verde-200 bg-white px-4 py-3 text-sm text-verde-900 outline-none transition-all duration-200 focus:border-verde-500 focus:ring-2 focus:ring-verde-500/20 hover:border-verde-300"
            >
              <option value="" disabled selected>Tipos de imóveis</option>
              <optgroup label="Residencial">
                {#each tiposResidencial as tipo}
                  <option value={tipo.slug}>{tipo.nome}</option>
                {/each}
              </optgroup>
              <optgroup label="Comercial">
                {#each tiposComercial as tipo}
                  <option value={tipo.slug}>{tipo.nome}</option>
                {/each}
              </optgroup>
            </select>
          </div>

          <div class="animate-fade-in-up [animation-delay:300ms]">
            <label for="localizacao" class="block text-sm font-medium text-verde-800 mb-1.5"> Localização </label>
            <select
              id="localizacao"
              name="localizacao"
              class="w-full rounded-md border border-verde-200 bg-white px-4 py-3 text-sm text-verde-900 outline-none transition-all duration-200 focus:border-verde-500 focus:ring-2 focus:ring-verde-500/20 hover:border-verde-300"
            >
              <option value="" disabled selected>Localidades</option>
              <optgroup label="Belo Horizonte">
                {#each locBH as loc}
                  <option value={loc.slug}>{loc.nome}</option>
                {/each}
              </optgroup>
              <optgroup label="Grande BH">
                {#each locGrandeBH as loc}
                  <option value={loc.slug}>{loc.nome}</option>
                {/each}
              </optgroup>
            </select>
          </div>

          <div class="animate-fade-in-up [animation-delay:400ms]">
            <button
              type="submit"
              class="flex items-center justify-center gap-2 w-full rounded-md bg-verde-500 px-6 py-3 text-sm font-medium text-white transition-all duration-200 hover:bg-verde-600 hover:shadow-lg hover:shadow-verde-500/25 active:scale-[0.98] md:w-auto"
            >
              Buscar Imóveis
              <svg class="size-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z"
                />
              </svg>
            </button>
          </div>
        </form>

        <div class="mt-6 border-t border-verde-200 pt-4 animate-fade-in-up [animation-delay:500ms]">
          <button
            type="button"
            class="text-sm text-verde-600 hover:text-verde-800 transition-colors duration-200 cursor-pointer"
            onclick={() => (mode = "code")}
          >
            Ou acesse a busca por código
          </button>
        </div>
      {:else}
        <form
          action="/imoveis"
          method="get"
          class="mt-8 space-y-5"
          in:fly={{ y: 20, duration: 400, delay: 100 }}
          out:fade={{ duration: 200 }}
        >
          <div>
            <label for="codigo" class="block text-sm font-medium text-verde-800 mb-1.5"> Código do Imóvel </label>
            <input
              id="codigo"
              name="codigo"
              type="text"
              placeholder="Ex.: IMV-0001"
              class="w-full rounded-md border border-verde-200 bg-white px-4 py-3 text-sm text-verde-900 placeholder:text-verde-300 outline-none transition-all duration-200 focus:border-verde-500 focus:ring-2 focus:ring-verde-500/20 hover:border-verde-300"
            />
          </div>

          <button
            type="submit"
            class="flex items-center justify-center gap-2 w-full rounded-md bg-verde-500 px-6 py-3 text-sm font-medium text-white transition-all duration-200 hover:bg-verde-600 hover:shadow-lg hover:shadow-verde-500/25 active:scale-[0.98] md:w-auto"
          >
            Buscar Imóveis
            <svg class="size-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z"
              />
            </svg>
          </button>
        </form>

        <div class="mt-6 border-t border-verde-200 pt-4">
          <button
            type="button"
            class="text-sm text-verde-600 hover:text-verde-800 transition-colors duration-200 cursor-pointer"
            onclick={() => (mode = "search")}
          >
            Ou acesse a busca padrão
          </button>
        </div>
      {/if}
    </div>

    <!-- Imagem hero -->
    <div class="hidden md:block">
      {#if heroImage}
        <img
          src={heroImage}
          alt="Urbana Boutique"
          class="aspect-4/3 w-full rounded-lg object-cover animate-fade-in-up [animation-delay:300ms]"
        />
      {:else}
        <div
          class="aspect-4/3 rounded-lg bg-verde-100 flex items-center justify-center animate-fade-in-up [animation-delay:300ms]"
        >
          <p class="text-verde-300 text-sm">Imagem</p>
        </div>
      {/if}
    </div>
  </div>
</section>
