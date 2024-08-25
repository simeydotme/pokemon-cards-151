<script>
  import { onMount } from "svelte";
  import Card from "./Card.svelte";

  // data / pokemon props
  export let id = undefined;
  export let name = undefined;
  export let number = undefined;
  export let set = undefined;
  export let types = undefined;
  export let subtypes = undefined;
  export let supertype = undefined;
  export let rarity = undefined;
  export let isReverse = false;

  // image props
  export let img = undefined;
  export let back = undefined;

  let cardSlot;
  let isInViewport = false;

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) {
          // If the element is not intersecting with the viewport, hide it
          isInViewport = false;
        } else {
          // If the element is intersecting with the viewport, show it
          isInViewport = true;
        }
      });
    },
    {
      threshold: 0.5, // Threshold for intersection, 1.0 means fully visible
      rootMargin: `50% 0px 50% 0px`, // Margin around viewport to check for intersection
    },
  );

  onMount(() => {
    observer.observe(cardSlot);
  });

  const server = import.meta.env.VITE_CDN;
  let setId = set;
  // const malieIndex = `https://cdn.malie.io/file/malie-io/tcgl/export/index.json`;
  // const malieJson = `https://cdn.malie.io/file/malie-io/tcgl/export/v0.1.9.4/sv3-5.en-US.json`;
  if (setId === "svp") {
    setId = "svbsp";
  } else {
    setId = setId.replace("pt", "-");
  }

  if ([1, 4, 7, 25, 133, 144, 146, 161].includes(parseInt(number))) {
    rarity = "Masterball Holo";
    isReverse = true;
  } else if (isReverse) {
    rarity = "Pokeball Holo";
    // change rarity for 20% of the cards
    if (Math.random() < 0.2) {
      rarity = "Masterball Holo";
    }
  }

  if (rarity === "Rare") {
    rarity = "Rare Holo";
  }

  if (rarity === "Ultra Rare") {
  }

  function isDefined(v) {
    return typeof v !== "undefined" && v !== null;
  }

  function isArray(v) {
    return typeof v !== "undefined" && Array.isArray(v);
  }

  function cardImage() {
    if (isDefined(img)) {
      return img;
    }
    if (isDefined(set) && isDefined(number)) {
      return `https://images.pokemontcg.io/${set.toLowerCase()}/${number}_hires.png`;
    }
    return "";
  }

  function foilImage() {
    let suffix = isReverse || ["Common", "Uncommon", "Pokeball Holo", "Masterball Holo"].includes(rarity) ? "ph" : "std";
    if ( ["Ultra Rare", "Special Illustration Rare", "Hyper Rare"].includes(rarity) ) {
      return `${ server }/etches/${setId}_en_${number.padStart(3, "0")}_${suffix}.etch.webp`;
    } else {
      return `${ server }/foils/${setId}_en_${number.padStart(3, "0")}_${suffix}.foil.webp`;
    }
  }

  function maskImage() {
    let suffix =
      isReverse ||
      ["Common", "Uncommon", "Pokeball Holo", "Masterball Holo"].includes(
        rarity,
      )
        ? "ph"
        : "std";
    return `${ server }/foils/${setId}_en_${number.padStart(3, "0")}_${suffix}.foil.webp`;
  }

  const proxy = {
    img: cardImage(),
    back,
    foil: foilImage(),
    mask: maskImage(),

    id,
    name,
    number,
    set,
    types,
    subtypes,
    supertype,
    rarity,
  };
</script>

<div bind:this={cardSlot}>
  {#if isInViewport}
    <Card {...proxy} />
  {:else}
    <div class="card-placeholder">
      <img
        src="https://tcg.pokemon.com/assets/img/global/tcg-card-back-2x.jpg"
        alt="Card Placeholder"
      />
    </div>
  {/if}
</div>

<style>
  .card-placeholder {
    border-radius: var(--card-radius);
  }
</style>
