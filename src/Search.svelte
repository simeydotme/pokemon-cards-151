<script>
  export let query = "";
</script>

<section class="search-area" title="minimum 3 letters to search...">
  <input
    type="search"
    name="search"
    id="search"
    bind:value={query}
    placeholder="eg: Charizard"
  />

  <svg
    xmlns="http://www.w3.org/2000/svg"
    class="icon icon-tabler icon-tabler-search"
    width="24"
    height="24"
    viewBox="0 0 24 24"
    stroke-width="1.25"
    stroke="currentColor"
    fill="none"
    stroke-linecap="round"
    stroke-linejoin="round"
  >
    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
    <path d="M10 10m-7 0a7 7 0 1 0 14 0a7 7 0 1 0 -14 0"></path>
    <path d="M21 21l-6 -6"></path>
  </svg>
</section>

{#if !query}
  <h3>Browse cards below, Or search for your favourite!</h3>
{/if}

<style>
  .search-area {
    font-size: 18px;
    display: grid;
    place-items: center start;
    max-width: 500px;
    margin: 120px 0 10px;
    padding: 5px;
    position: sticky;
    top: 10px;
    border-radius: 0.66em;
    backdrop-filter: blur(5px);
    z-index: 98;
  }

  @media screen and (min-width: 900px) {
    .search-area {
      margin: 120px 50px 0;
      font-size: 22px;
    }
    h3 {
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
    background: hsla(220, 7%, 17%, 0.66);
    color: white;
    outline: none;
    transition: all 0.5s ease;
    box-shadow:
      0 5px 20px hsla(220, 7%, 20%, 0.75),
      0 5px 10px hsla(220, 7%, 20%, 0.75);

    grid-row: 1;
    grid-column: 1;
    width: 100%;
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

  .icon-tabler-search {
    grid-row: 1;
    grid-column: 1;
    place-self: center end;
    margin-right: 10px;
    opacity: 0.5;
    transition: all 0.5s ease;
  }

  input:active + .icon,
  input:focus + .icon,
  input:hover + .icon {
    opacity: 0.2;
  }

  h3 {
    font-family: Roboto;
    font-size: inherit;
    font-weight: normal;
    margin-block: 10px;
  }
</style>
