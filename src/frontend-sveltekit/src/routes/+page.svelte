<script>
	import { onMount, onDestroy } from 'svelte';
	import { browser } from '$app/environment';
	import { formatUrl } from '$lib/env';

	import { HubConnectionBuilder } from '@microsoft/signalr';

	import { getToastStore, getModalStore, focusTrap } from '@skeletonlabs/skeleton';

	import Counter from './Counter.svelte';

	const toastStore = getToastStore();
	const modalStore = getModalStore();

	const hubUrl = formatUrl('/hubs/monitorHub');

	let signalRConnectionState = 'Unknown';
	let signalRMessageCount = 0;
	let lastMessage = 'None';
	let healthChecks = { };
	let healthCheckList = [];
	let connection;

	async function refetch() {
		data = await jsonRequest(formatUrl(`/api/collaboration/${tenant}/value-streams`));
	}

	async function start() {
		if (!browser) return;

		connection = new HubConnectionBuilder().withUrl(hubUrl).withAutomaticReconnect().build();

		connection.on('ClientHeartbeat', (message) => {
			healthChecks[message.hostname] = {
				status: message.status,
				ts: new Date(Date.now()).toISOString()
			};
			lastMessage = message.hostname + message.status;
			signalRMessageCount++;

			let list = [];
			for (const [key, value] of Object.entries(healthChecks)) {
				list.push({ host: key, status: value.status, ts: value.ts });
			}
			healthCheckList = list;
		});

		connection.on('ValueStreamCancelled', async function (evt) {
			signalRMessageCount++;
			refetch();
		});

		try {
			await connection.start();
			connection.send('Subscribe', 'clients');

			connection.onreconnecting((error) => {
				signalRConnectionState = 'Reconnecting...';
				console.log(`Connection lost due to error "${error}". Reconnecting.`);
			});

			connection.onreconnected((connectionId) => {
				signalRConnectionState = 'Reconnected';
				console.log(`Connection reestablished. Connected with connectionId "${connectionId}"`);
			});
			signalRConnectionState = connection.state;
		} catch (err) {
			signalRConnectionState = connection.state;
			signalRConnectionState = err.message;
			await start();
		}
	}

	export let data = { tenant: 'pvo', valueStreams: null, position: 0, revision: 0 };

	$: ({ tenant, valueStreams, position, revision } = data);

	async function stop() {
		if (!browser) return;
		connection.send('Unsubscribe', 'clients');
		await connection.stop();
	}

	onMount(async () => {
		if (!browser) return;
		await start();
		return () => {
			if (!browser) return;
			connection.stop();
		};
	});

	onDestroy(async () => {
		await stop();
	});
</script>

<svelte:head>
	<title>Boto GP</title>
	<meta name="description" content="Svelte demo app" />
	<link
		rel="stylesheet"
		href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
		integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
		crossorigin="anonymous"
	/>
</svelte:head>

<section>
	<h1>
		<b>Boto</b>GP
		<br /> the home of <b>bot-race</b>
	</h1>

	<Counter />

	<p>
		Last message: <strong>{lastMessage}</strong>
	</p>
	<p>
		We have received <strong>{signalRMessageCount}</strong> messages {signalRConnectionState}
	</p>

	<div class="container">
		<div class="row mt-2">
			{#each healthCheckList as h}
				<div class="w-25">
					<div class="card w-100 m-1">
						<h5 class="card-header">{h.host} <small> - PVO</small></h5>
						<div class="card-body">
							<h5>{h.status}</h5>
							<p class="card-text">{h.ts}</p>
						</div>
					</div>
				</div>
			{/each}
		</div>
	</div>
</section>

<style>
	section {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		/* flex: 0.6; */
	}

	h1 {
		width: 100%;
	}
</style>
