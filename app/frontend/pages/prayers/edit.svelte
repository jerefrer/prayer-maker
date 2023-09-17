<script>
  import Prayer from "../../components/Prayer.svelte";
  export let prayer_id;
  export let prayer;
</script>

<Prayer prayerId={prayer_id} {prayer} />
