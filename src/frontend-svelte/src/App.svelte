<script>
	import { onMount } from 'svelte';
	
	import Toast from './Toast.svelte';

	export let name;
	let items;
	let msg = 'My rrrrr sdf gessage';

	$: fetch(`https://localhost:5001/weatherforecast`)
	.then(r => r.json())
	.then(data => {
	items = data;
	window.scrollTo(0, 0);
	// console.log(items);
	});

</script>

<main>
	<h1>Hello {name.toLowerCase()}!</h1>

	<input type="text" bind:value={msg} />
	<button on:click={() => {
		window.pushToast(msg)
	}}>
	sdfsfsdfs
	</button>

<Toast />
</main>

<style>
	main {
		text-align: center;
		padding: 1em;
		max-width: 240px;
		margin: 0 auto;
	}
	/*
	h1 {
		color: #ff3e00;
		font-size: 4em;
		font-weight: 100;
	}
	*/

	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>