<script>
	import { onMount, onDestroy } from 'svelte';
	import { browser } from '$app/environment';
	import { formatUrl } from '$lib/env';

	import { HubConnectionBuilder } from '@microsoft/signalr';

	const hubUrl = formatUrl('/hubs/monitorHub');

	let signalRConnectionState = 'Unknown';
	let signalRMessageCount = 0;
	let lastMessage = 'None';
	
	let healthCheckList = [];
	let filteredHealthCheckList = [];
	let connection;

	let filter = '';

	$: filter, healthCheckList, checkValuesChange();
	function checkValuesChange() {
		filteredHealthCheckList = healthCheckList.filter((h) => h.host.includes(filter));
	}

	async function start() {
		if (!browser) return;

		connection = new HubConnectionBuilder().withUrl(hubUrl).withAutomaticReconnect().build();

		connection.on('ClientSyncStateNotification', (message) => {
			console.log(message);
			const i = healthCheckList.findIndex((h) => h.host === message.hostname);
			if (i >= 0) {
				healthCheckList[i].progress = message.progress;
				healthCheckList[i].status = message.status;
				healthCheckList[i].percent = Math.floor((100 * message.progress.completed) / message.progress.total
				);
				healthCheckList[i].ts = new Date(Date.now()).toISOString();
			} else {
				healthCheckList[healthCheckList.length] = {
					host: message.hostname,
					progress: message.progress,
					status: message.status,
					percent: Math.floor((100 * message.progress.completed) / message.progress.total),
					ts: new Date(Date.now()).toISOString()
				};
			}

			signalRMessageCount++;
		});

		connection.on('ClientHeartbeat', (message) => {
			const i = healthCheckList.findIndex((h) => h.host === message.hostname);
			if (i >= 0) {
				healthCheckList[i].health = message.status;
				healthCheckList[i].ts = new Date(Date.now()).toISOString();
			} else {
				healthCheckList[healthCheckList.length] = {
					host: message.hostname,
					health: message.status,
					ts: new Date(Date.now()).toISOString()
				};
			}

			lastMessage = message.hostname + message.status;
			signalRMessageCount++;
		});

		try {
			await connection.start();
			connection.send('Subscribe', `clients`);

			connection.onreconnecting((error) => {
				signalRConnectionState = 'Reconnecting...';
				console.log(`Connection lost due to error "${error}". Reconnecting.`);
			});

			connection.onreconnected((connectionId) => {
				signalRConnectionState = 'Reconnected';
				connection.send('Unsubscribe', `clients`);
				connection.send('Subscribe', `clients`);
				console.log(`Connection reestablished. Connected with connectionId "${connectionId}"`);
			});
			signalRConnectionState = connection.state;
		} catch (err) {
			signalRConnectionState = connection.state;
			signalRConnectionState = err.message;
			await start();
		}
	}

	async function stop() {
		if (!browser) return;
		connection.send('Unsubscribe', `clients`);
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
	<title>Practice - Boto GP</title>
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
		<b>Practice</b> makes<br />perf<b>ect</b>
	</h1>

	<form>
		<div class="form-group">
			<input
				class="form-control form-control-lg"
				placeholder="Filter for hostname here..."
				type="text"
				bind:value={filter}
			/>
		</div>
	</form>

	<div class="container">
		<div class="row mt-2">
			{#each filteredHealthCheckList as h}
				<div class="w-25">
					<div class="card w-100 m-1">
						<h5 class="card-header">{h.host} <small> - {h.health}</small></h5>
						<div class="card-body">
							<h5>{h.status}</h5>
							<p class="card-text">{h.ts}</p>

							{#if h.progress && h.progress.completed < h.progress.total}
								<div class="progress">
									<div
										class="progress-bar"
										role="progressbar"
										style="width: {h.percent}%;"
										aria-valuenow="25"
										aria-valuemin="0"
										aria-valuemax="100"
									>
										{h.progress.completed}/{h.progress.total}
									</div>
								</div>
							{/if}
							{#if h.progress && h.progress.completed == h.progress.total}
								<div class="progress">
									<div
										class="progress-bar bg-success"
										role="progressbar"
										style="width: 100%"
										aria-valuenow="25"
										aria-valuemin="0"
										aria-valuemax="100"
									></div>
								</div>
							{/if}
							{h.status}
						</div>
					</div>
				</div>
			{/each}
		</div>
	</div>

	<p class="text-muted">
		Last message: <strong>{lastMessage}</strong>
	</p>
	<p class="text-muted">
		We have received <strong>{signalRMessageCount}</strong> messages {signalRConnectionState}
	</p>
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
