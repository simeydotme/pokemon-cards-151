<script>
  import { activeCard } from "./lib/stores/activeCard.js";
  export let cardGrid;
  $: active = cardGrid && cardGrid.contains($activeCard);
</script>

<section class="card-grid" class:active bind:this={cardGrid}>
  <slot />
</section>

<style>
  .card-grid {
    display: grid;
    grid-template-columns: 1fr 1px 1px;
    grid-gap: 80px 0;
    transform-style: preserve-3d;
    height: 100%;
    max-width: 1200px;
    margin: auto;
    padding: 50px;
    position: relative;
    scroll-margin-top: 100px;
  }

  .card-grid.active {
    z-index: 99;
    isolation: isolate;
  }

  @media screen and (min-width: 900px) {
    .card-grid {
      grid-template-columns: 1fr 1fr 1fr;
      grid-gap: 50px 2vw;
    }
  }

  @media screen and (max-width: 900px) {
    :global(.card-grid > .card-slot) {
      grid-column: 1;
      grid-row: var(--row, auto);
      transition:
        opacity 0.2s ease,
        transform 0.2s ease;
    }

    :global(.card-grid > .card-slot:nth-child(3n + 1)) {
      position: relative;
      left: -50px;
      top: 40px;
      z-index: 50;
      transform: translate3d(0, 0, 0.1px) rotateZ(-5deg);
      opacity: 1;
    }
    :global(.card-grid > .card-slot:nth-child(3n + 2)) {
      position: relative;
      left: 0px;
      top: 10px;
      z-index: 49;
      transform: translate3d(0, 0, 0.1px) rotateZ(0deg);
      opacity: 0.99;
    }
    :global(.card-grid > .card-slot:nth-child(3n + 3)) {
      position: relative;
      left: 50px;
      top: -20px;
      z-index: 48;
      transform: translate3d(0, 0, 0.1px) rotateZ(5deg);
      opacity: 0.99;
    }
    :global(.card-grid > .card-slot:has(.card.is-scaled)) {
      opacity: 1;
    }

    /* :global( .card-grid > .card-slot:nth-child(n+4):nth-child(-n+6) ) { --row: 2; }
		:global( .card-grid > .card-slot:nth-child(n+7):nth-child(-n+9) ) { --row: 3; }
		:global( .card-grid > .card-slot:nth-child(n+10):nth-child(-n+12) ) { --row: 4; }
		:global( .card-grid > .card-slot:nth-child(n+13):nth-child(-n+15) ) { --row: 5; }
		:global( .card-grid > .card-slot:nth-child(n+16):nth-child(-n+18) ) { --row: 6; }
		:global( .card-grid > .card-slot:nth-child(n+19) ) {
			grid-row: auto;
			grid-column: auto;
			transform: none!important;
			left: 0!important;
			top: 0!important;
		} */
  }

  @media screen and (min-width: 600px) and (max-width: 900px) {
    .card-grid {
      max-width: 420px;
      margin: auto;
    }
    :global(.card-grid > .card-slot:nth-child(3n + 1)) {
      left: -100px;
      top: 10px;
      transform: translate3d(0, 0, 0.1px) rotateZ(-5deg);
    }
    :global(.card-grid > .card-slot:nth-child(3n + 2)) {
      left: 0px;
      top: -10px;
      transform: translate3d(0, 0, 0.1px) rotateZ(0deg);
    }
    :global(.card-grid > .card-slot:nth-child(3n + 3)) {
      left: 100px;
      top: 0px;
      transform: translate3d(0, 0, 0.1px) rotateZ(5deg);
    }
  }
</style>
