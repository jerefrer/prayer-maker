<script>
  import { v4 as uuid } from "uuid";
  import PrayerGroup from "./PrayerGroup.svelte";

  import { Repo } from "@automerge/automerge-repo";
  import { BroadcastChannelNetworkAdapter } from "@automerge/automerge-repo-network-broadcastchannel";
  import { IndexedDBStorageAdapter } from "@automerge/automerge-repo-storage-indexeddb";
  import { BrowserWebSocketClientAdapter } from "@automerge/automerge-repo-network-websocket";
  import { setContextRepo } from "@automerge/automerge-repo-svelte-store";

  export let prayerId;
  export let prayer;

  const repo = new Repo({
    network: [
      new BroadcastChannelNetworkAdapter(),
      new BrowserWebSocketClientAdapter("ws://localhost:3030"),
    ],
    storage: new IndexedDBStorageAdapter(),
  });

  setContextRepo(repo);

  let rootDocUrl = localStorage.rootDocUrl;
  if (!rootDocUrl) {
    const doc = repo.create();
    doc.change((d) => {
      d.count = 0;
      d.prayer = prayer;
    });
    localStorage.rootDocUrl = rootDocUrl = doc.url;
  }

  function handleArrowsNavigation({ keyCode }) {
    if (keyCode !== 38 && keyCode !== 40) return;

    const current = document.activeElement;
    const items = [...document.querySelectorAll("[contenteditable]")];
    const currentIndex = items.indexOf(current);
    let newIndex;

    if (currentIndex === -1) {
      newIndex = 0;
    } else {
      if (keyCode === 38) {
        newIndex = (currentIndex + items.length - 1) % items.length;
      } else {
        newIndex = (currentIndex + 1) % items.length;
      }
    }

    current.blur();
    items[newIndex].focus();
  }

  function insertGroupBefore(index) {
    insertGroup(index);
  }

  function insertGroupAtTheEnd() {
    insertGroup();
  }

  function insertGroup(index) {
    let groupId = prayer.groups[index].id;
    let newGroup = {
      id: uuid(),
      tibetan: "",
      phonetics: "",
      english: "",
    };
    prayer.groups.splice(index, 0, newGroup);
    prayer.groups = prayer.groups;
    fetch(`/prayers/${prayerId}/insert_group`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")
          .content,
      },
      body: JSON.stringify({ group_id: groupId, new_group: newGroup }),
    });
  }
</script>

<svelte:window on:keydown={handleArrowsNavigation} />

<div>
  <hgroup>
    <h1>{prayer.title.tibetan.full}</h1>
    <h1>{prayer.title.english.title}</h1>
    <h2>{prayer.title.english.subtitle}</h2>
  </hgroup>

  {#each prayer.groups as group, index (group.id)}
    <div class="add-button" on:click={() => insertGroupBefore(index)} />
    <PrayerGroup {prayerId} {index} documentUrl={rootDocUrl} />
  {/each}
  <div class="add-button" on:click={insertGroupAtTheEnd} />
</div>

<style>
  .add-button {
    position: relative;
    width: 100%;
    height: 20px;
    color: transparent;
    text-align: center;
    user-select: none;
    cursor: pointer;
    transition: 0.2s ease-in-out;
  }
  .add-button:after {
    opacity: 0;
    content: "+";
    width: 36px;
    height: 36px;
    position: absolute;
    top: -8px;
    border-radius: 50%;
    background: rgba(0, 0, 0, 0.2);
    transition: 0.2s ease-in-out;
    transform: rotate(-20deg) scale(0);
  }
  .add-button:hover:not(:focus) {
    color: var(--color);
    background: rgba(0, 0, 0, 0.2);
  }
  .add-button:hover:not(:focus):after {
    opacity: 1;
    transform: rotate(0deg) scale(1);
  }
</style>
