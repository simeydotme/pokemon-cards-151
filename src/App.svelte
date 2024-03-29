<script>
  import { onMount } from "svelte";

  import Search from "./Search.svelte";
  import CardList from "./Cards.svelte";
  import Card from "./lib/components/CardProxy.svelte";
  import { flip } from "svelte/animate";
  import { quintOut } from "svelte/easing";

  let initialCards;

  let query = "";
  let isLoading = true;

  const getCards = async () => {
    let promiseArray = [];
    let cardFetch = await fetch("/data/cards.json");
    let cards = await cardFetch.json();
    return cards;
  };

  const loadCards = async () => {
    return getCards().then((cards) => {
      window.cards = cards;
      let cardsMap = cards.map((card) => {
        if (card.rarity === "Common" || card.rarity === "Uncommon") {
          card.isReverse = !!Math.round(Math.random());
        }
        card.set = card.set.id;
        return card;
      });
      initialCards = cardsMap;
      isLoading = false;
    });
  };

  onMount(() => {
    loadCards();
    const $headings = document.querySelectorAll("h1,h2,h3");
    const $anchor = [...$headings].filter((el) => {
      const id = el.getAttribute("id")?.replace(/^.*?-/g, "");
      const hash = window.location.hash?.replace(/^.*?-/g, "");
      return id === hash;
    })[0];
    if ($anchor) {
      setTimeout(() => {
        $anchor.scrollIntoView();
      }, 100);
    }
  });

  $: {
    if (query.length > 0) {
      initialCards = window.cards.filter((card) => {
        return card.name.toLowerCase().includes(query.toLowerCase());
      });
    } else {
      initialCards = window.cards;
    }
  }
</script>

<main>
  <header>
    <h1 id="⚓-top">Pokemon Cards <sup>151</sup></h1>

    <p class="author">
      By <a href="https://twitter.com/simeydotme"
        ><svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"
          ><title>Twitter</title><path
            d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"
          /></svg
        > @simeydotme</a
      >
      |
      <em
        ><a href="https://github.com/simeydotme/pokemon-cards-css"
          ><svg
            role="img"
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
            ><title>GitHub</title><path
              d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"
            /></svg
          > Simon Goellner</a
        ></em
      >
    </p>

    <section class="intro" id="⚓-intro">
      <p>
        A re-build of my <a href="https://poke-holo.simey.me"
          >Pokemon Realistic Cards project</a
        >, but for the legendary Pokemon 151 set (sv3.6);
      </p>
      <p>
        This is a collection of advanced CSS styles to create
        <mark>realistic-looking effects</mark> for the faces of Pokemon cards.
        The cards use <mark>3d transforms</mark>, <mark>filters</mark>,
        <mark>blend modes</mark>,
        <mark>css gradients</mark> and interactions to provide a unique experience
        when taking a closer look!
      </p>
    </section>

    <div class="showcase">
      <img
        src="https://poke-holo.b-cdn.net/foils/151/logo.webp"
        alt="Pokemon Scarlet and Violet 151 logo"
      />
    </div>

    <section class="info">
      <h2>Click on a Card to take a Closer look!</h2>

      <hr />

      <p class="small">
        I'm using SvelteJS to handle interactivity and state; <strong>
          assigning values to css custom properties
        </strong>
        (variables) which in-turn drive the effects and 3d transforms.
        <br />
        <a
          href="https://github.com/simeydotme/pokemon-cards-151/tree/main/public/css"
          >Source code is in the repository</a
        >.
      </p>
    </section>
  </header>

  <Search bind:query />

  <CardList>
    {#if isLoading}
      loading...
    {:else}
      {#each initialCards as card, index (card.id)}
        <div
          class="card-slot"
          style="--row: {Math.ceil((index + 1) / 3)};"
          animate:flip={{ delay: 250, duration: 250, easing: quintOut }}
        >
          <Card
            id={card.id}
            name={card.name}
            img={card.images.large}
            number={card.number}
            types={card.types}
            supertype={card.supertype}
            subtypes={card.subtypes}
            set={card.set}
            rarity={card.rarity}
            isReverse={card.isReverse}
          />
        </div>
      {/each}
    {/if}
  </CardList>
</main>

<div class="back-to-top">
  <a href="#⚓-top">Back to Top</a>
</div>

<style>
  .back-to-top a {
    color: inherit;
    text-decoration: none;
    z-index: 999;
  }
  img {
    max-width: 100%;
  }
  .card-slot:has(.card.is-scaled) {
    isolation: isolate;
    z-index: 60;
  }
  main {
    padding-bottom: 100vh;
  }
  p {
    margin-bottom: 1em;
  }
</style>
