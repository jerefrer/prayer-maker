<script>
  import { onMount } from "svelte";
  import { ToggleSwitch } from "fluent-svelte";
  import { router } from "@inertiajs/svelte";

  export let prayerId;
  export let group;

  function now() {
    return new Date().getTime();
  }

  let timer;
  let initializedAt = now();

  function debouncedPostGroup(group) {
    clearTimeout(timer);
    timer = setTimeout(() => {
      fetch(`/prayers/${prayerId}/update_group`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")
            .content,
        },
        body: JSON.stringify({ group: group }),
      });
    }, 750);
  }

  // $: {
  //   if (now() - initializedAt > 1000) {
  //     debouncedPostGroup(group);
  //   }
  // }
</script>

<div class="group" class:small-writings={group.smallWritings}>
  <div class="fields">
    <div class="field">
      <div
        contenteditable="plaintext-only"
        bind:innerHTML={group.tibetan}
        on:keydown={() => debouncedPostGroup(group)}
        class="tibetan"
        spellcheck="false"
      />
    </div>
    {#if !(group.practiceTitle || group.smallWritings)}
      <div class="field phonetics">
        <div
          contenteditable="plaintext-only"
          bind:innerHTML={group.phonetics}
          on:keydown={() => debouncedPostGroup(group)}
          class="phonetics"
          spellcheck="false"
        />
      </div>
    {/if}
    <div class="field translation">
      <div
        contenteditable="plaintext-only"
        bind:innerHTML={group.english}
        on:keydown={() => debouncedPostGroup(group)}
      />
    </div>
  </div>
  <div class="options">
    <ToggleSwitch bind:checked={group.practiceTitle}>
      Practice title
    </ToggleSwitch>
    {#if group.practiceTitle}
      <ToggleSwitch bind:checked={group.linkInIndex}>
        Link in Table of Contents
      </ToggleSwitch>
    {:else}
      <ToggleSwitch bind:checked={group.smallWritings}>
        Small writings
      </ToggleSwitch>
    {/if}
  </div>
</div>

<style>
  .group {
    display: flex;
  }

  .group .fields {
    flex: 1;
  }

  .group .options {
    display: flex;
    width: 200px;
    flex-direction: column;
    /* border-top: 1px solid grey; */
    /* border-bottom: 1px solid grey; */
    margin-left: 2em;
    padding-top: 0.5em;
    padding-bottom: 0.5em;
    opacity: 0.5;
  }

  [contenteditable] {
    padding: 5px;
    cursor: pointer;
    border-radius: 4px;
    transition: 0.2s ease-in-out;
  }
  [contenteditable]:hover:not(:focus) {
    background: rgba(0, 0, 0, 0.2);
  }

  .tibetan {
    /* font-family: DDC_Uchen; */
    /* font-size: 19px; */
    font-family: "TibetanChogyalUnicode-170221";
    font-size: 36px;
    line-height: 1em;
    padding: 10px 5px;
  }
  .small-writings .tibetan {
    font-size: 26px;
  }

  .phonetics {
    font-family: "Calibri";
    font-size: 16px;
  }

  .translation {
    font-family: "Times New Roman";
    font-size: 14px;
    padding-left: 20px;
  }
  .small-writings .translation {
    font-size: 12px;
    font-style: italic;
    padding-left: 0;
  }
</style>
