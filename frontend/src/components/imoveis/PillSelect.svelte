<script lang="ts">
  interface Option {
    value: number;
    label: string;
  }

  interface Props {
    label: string;
    options: Option[];
    selected: number | null;
    id: string;
  }

  let { label, options, selected = $bindable(), id }: Props = $props();

  function toggle(value: number) {
    selected = selected === value ? null : value;
  }
</script>

<div>
  <p class="mb-1.5 text-xs font-medium text-verde-600">{label}</p>
  <div class="flex gap-1" role="group" aria-label={label}>
    {#each options as option}
      <button
        type="button"
        id="{id}-{option.value}"
        class="flex h-8 p-2 items-center justify-center rounded-full border text-xs font-medium transition-all duration-150 cursor-pointer
          {option.label.length > 1 ? 'px-2.5' : 'w-8'}
          {selected === option.value
          ? 'bg-verde-500 text-white border-verde-500'
          : 'bg-white text-verde-700 border-verde-200 hover:border-verde-400 hover:bg-verde-50'}"
        aria-pressed={selected === option.value}
        onclick={() => toggle(option.value)}
      >
        {option.label}
      </button>
    {/each}
  </div>
</div>
