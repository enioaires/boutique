<script lang="ts">
  interface Props {
    min: number;
    max: number;
    step: number;
    valueLow: number;
    valueHigh: number;
    formatLabel?: (value: number) => string;
    label: string;
    id: string;
    disabled?: boolean;
  }

  let {
    min,
    max,
    step,
    valueLow = $bindable(),
    valueHigh = $bindable(),
    formatLabel = (v: number) => String(v),
    label,
    id,
    disabled = false,
  }: Props = $props();

  const percentLow = $derived(((valueLow - min) / (max - min)) * 100);
  const percentHigh = $derived(((valueHigh - min) / (max - min)) * 100);

  function onLowInput(e: Event) {
    const v = Number((e.target as HTMLInputElement).value);
    valueLow = Math.min(v, valueHigh - step);
  }

  function onHighInput(e: Event) {
    const v = Number((e.target as HTMLInputElement).value);
    valueHigh = Math.max(v, valueLow + step);
  }
</script>

<div class={disabled ? "opacity-35 pointer-events-none" : ""}>
  <p class="mb-1.5 text-xs font-medium text-verde-600">{label}</p>

  <div class="mb-2 flex items-center justify-between text-xs font-medium text-verde-800">
    <span class="rounded bg-verde-50 px-1.5 py-0.5">{formatLabel(valueLow)}</span>
    <span class="rounded bg-verde-50 px-1.5 py-0.5">{formatLabel(valueHigh)}</span>
  </div>

  <div class="range-slider relative h-2 rounded-full bg-verde-200">
    <div
      class="absolute top-0 h-full rounded-full bg-verde-500"
      style="left: {percentLow}%; right: {100 - percentHigh}%"
    ></div>

    <input
      type="range"
      {min}
      {max}
      {step}
      value={valueLow}
      oninput={onLowInput}
      {disabled}
      aria-label="{label} mínimo"
      aria-valuenow={valueLow}
      aria-valuetext={formatLabel(valueLow)}
      id="{id}-low"
      class="range-thumb absolute inset-0 w-full appearance-none bg-transparent pointer-events-none"
    />

    <input
      type="range"
      {min}
      {max}
      {step}
      value={valueHigh}
      oninput={onHighInput}
      {disabled}
      aria-label="{label} máximo"
      aria-valuenow={valueHigh}
      aria-valuetext={formatLabel(valueHigh)}
      id="{id}-high"
      class="range-thumb absolute inset-0 w-full appearance-none bg-transparent pointer-events-none"
    />
  </div>
</div>

<style>
  .range-thumb::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 18px;
    height: 18px;
    border-radius: 50%;
    background: white;
    border: 2.5px solid oklch(50.8% 0.118 165.612);
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.15);
    cursor: grab;
    pointer-events: auto;
    position: relative;
    z-index: 1;
  }

  .range-thumb::-moz-range-thumb {
    width: 18px;
    height: 18px;
    border-radius: 50%;
    background: white;
    border: 2.5px solid oklch(50.8% 0.118 165.612);
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.15);
    cursor: grab;
    pointer-events: auto;
    position: relative;
    z-index: 1;
  }

  .range-thumb:active::-webkit-slider-thumb {
    cursor: grabbing;
    box-shadow: 0 0 0 4px oklch(50.8% 0.118 165.612 / 0.15);
  }

  .range-thumb:active::-moz-range-thumb {
    cursor: grabbing;
    box-shadow: 0 0 0 4px oklch(50.8% 0.118 165.612 / 0.15);
  }

  .range-thumb::-webkit-slider-runnable-track {
    height: 8px;
  }

  .range-thumb::-moz-range-track {
    height: 8px;
    background: transparent;
  }
</style>
