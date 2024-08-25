<script>
  export let query = "";
  export let cardSearch;

  const debounce = (func, wait) => {
    let timeout;
    return function () {
      const context = this;
      const args = arguments;
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(context, args), wait);
    };
  };

  const updateUrl = debounce((e) => {
    const url = new URL(window.location.href);
    const previousSearchParams = url.searchParams.get("poke");
    if (query === "") {
      url.searchParams.delete("poke");
    } else {
      url.searchParams.set("poke", query);
    }
    if ( url.searchParams.get("poke") !== previousSearchParams ) {
      window.history.pushState({}, "", url);
    }
  }, 500);

  $: updateUrl(query);
</script>

<span bind:this={cardSearch} />

<section class="search-area" title="minimum 3 letters to search...">
  <input
    type="search"
    name="search"
    id="search"
    bind:value={query}
    placeholder="eg: Charizard"
  />

  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <svg
    xmlns="http://www.w3.org/2000/svg"
    class="icon icon-tabler icons-tabler-outline icon-tabler-pokeball"
    class:searching={!!query}
    width="24"
    height="24"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    stroke-width="1.25"
    stroke-linecap="round"
    stroke-linejoin="round"
    on:click={() => (query = query === "" ? "starters" : "")}
  >
    <path stroke="none" d="M0 0h24v24H0z" fill="none" />

    <path
      class="search--empty"
      d="M12 12m-9 0a9 9 0 1 0 18 0a9 9 0 1 0 -18 0"
    />
    <path class="search--empty" d="M12 12m-3 0a3 3 0 1 0 6 0a3 3 0 1 0 -6 0" />
    <path class="search--empty" d="M3 12h6" />
    <path class="search--empty" d="M15 12h6" />

    <path
      class="search--full"
      d="M20.04 16.048a9 9 0 0 0 -12.083 -12.09m-2.32 1.678a9 9 0 1 0 12.737 12.719"
    />
    <path
      class="search--full"
      d="M9.884 9.874a3 3 0 1 0 4.24 4.246m.57 -3.441a3.012 3.012 0 0 0 -1.41 -1.39"
    />
    <path class="search--full" d="M3 12h6m7 0h5" />
    <path class="search--full" d="M3 3l18 18" />
  </svg>
</section>

{#if !query}
  <h3>Browse cards below, Or search for your favourite!</h3>
{/if}

<nav>
  <ul>
    <li>
      <a
        href="?poke=starters"
        on:click|preventDefault={() => (query = "starters")}>Starters</a
      >
    </li>
    <li>
      <a
        href="?poke=lets-go"
        on:click|preventDefault={() => (query = "lets-go")}>Let's Go</a
      >
    </li>
    <li>
      <a
        href="?poke=starter-evolutions"
        on:click|preventDefault={() => (query = "starter-evolutions")}
        >Starter Evolutions</a
      >
    </li>
    <li>
      <a
        href="?poke=shinies"
        on:click|preventDefault={() => (query = "shinies")}>Shinies</a
      >
    </li>
    <li>
      <a
        href="?poke=ex-cards"
        on:click|preventDefault={() => (query = "ex-cards")}>Ex Cards</a
      >
    </li>
    <li>
      <a
        href="?poke=illustrations"
        on:click|preventDefault={() => (query = "illustrations")}
        >Illustrations</a
      >
    </li>
    <li>
      <a
        href="?poke=full-arts"
        on:click|preventDefault={() => (query = "full-arts")}>Full Arts</a
      >
    </li>
  </ul>
</nav>

<style>
  .search-area {
    font-size: 18px;
    display: grid;
    grid-template-columns: 1fr;
    place-items: center normal;
    max-width: 500px;
    margin: 120px 0 10px;
    padding: 10px;
    position: sticky;
    top: 0.66em;
    border-radius: 0.66em;
    backdrop-filter: blur(4px) saturate(1.1) contrast(1.1) brightness(1.1);
    isolation: isolate;
    transform: translate3d(0, 0, 0.1px);
    z-index: 98;
    box-shadow:
      0 5px 20px hsla(220, 7%, 20%, 0.1),
      0 5px 10px hsla(220, 7%, 20%, 0.2);
  }

  @media screen and (min-width: 900px) {
    .search-area {
      margin: 120px 50px 0;
      font-size: 22px;
    }
    h3,
    nav {
      margin-inline: 60px;
    }
  }

  input {
    font-family: Roboto;
    font-size: inherit;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 0.5em;
    padding: 0.5em 2em 0.5em 0.75em;
    margin: 0;
    background: hsla(220, 7%, 17%, 0.8);
    color: white;
    outline: none;
    transition: all 0.5s ease;
    backdrop-filter: blur(5px);

    grid-row: 1;
    grid-column: 1;
  }

  input:active,
  input:focus,
  input:hover {
    background: hsla(220, 7%, 17%, 0.88);
  }

  input:active,
  input:focus {
    border: 1px solid var(--primary);
  }

  input:active:invalid,
  input:focus:invalid {
    border: 1px solid var(--error);
  }

  .icon {
    grid-row: 1;
    grid-column: 1;
    place-self: center end;
    margin-right: 10px;
    opacity: 0.5;
    transition: all 0.5s ease;
    cursor: pointer;
  }

  input:active + .icon,
  input:focus + .icon,
  input:hover + .icon {
    opacity: 0.2;
  }

  .search--empty,
  .search--full {
    transition: all 0.5s ease;
  }

  .search--full {
    opacity: 0;
  }

  .searching .search--full {
    transition: all 0.5s ease;
    opacity: 1;
  }
  .searching .search--empty {
    opacity: 0;
  }

  h3 {
    font-family: Roboto;
    font-size: inherit;
    font-weight: normal;
    margin-block: 10px;
  }

  nav {
    margin-block: 25px;
  }

  nav ul {
    list-style: none;
    padding: 0;
    display: flex;
    flex-wrap: wrap;
    gap: 1em;
  }

  nav li {
    margin-bottom: 0.5em;
  }
</style>
