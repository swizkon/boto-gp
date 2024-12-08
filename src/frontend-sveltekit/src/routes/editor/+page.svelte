<script>
	const env = import.meta.env;
	import { onMount, onDestroy } from 'svelte';
	import { browser } from '$app/environment';

	import { HubConnectionBuilder } from '@microsoft/signalr';

	const baseUrl = env.PROD ? '' : 'https://localhost:7081';
	const hubUrl = `${baseUrl}/hubs/monitorHub`;

	let signalRConnectionState = 'Unknown';
	let signalRMessageCount = 0;
	let lastMessage = 'None';
		
	let circuitFilter = '';
	let healthCheckList = [];
	let filteredHealthCheckList = [];

	$: circuitFilter, healthCheckList, checkValuesChange();
	function checkValuesChange() {
		filteredHealthCheckList = healthCheckList.filter((h) => h.circuit.includes(circuitFilter));
	}

	let connection;

	async function start() {
		if (!browser) return;

		connection = new HubConnectionBuilder().withUrl(hubUrl).withAutomaticReconnect().build();

		connection.on('CircuitNotificationLog', (message) => {
			signalRMessageCount++;

			const firstApplicationLog = message.applicationLogs.map((a) => a.unixTimestamp).sort()[0];

			const datao = {
				...message,
				applicationLogs: message.applicationLogs.map((a) => {

					return {
						...a,
						time: a.unixTimestamp - firstApplicationLog,
						messages: a.messages.map((m) => {
							console.log('m', m);
							return {
								...m,
								timestamp: Date.parse(m.timestamp) - firstApplicationLog,
								icon:
									m.severity === 'critical' || m.severity === 'error'
										? 'icon-error'
										: m.severity === 'warn'
											? 'icon-warning'
											: m.severity === 'trace' ||
												  m.severity === 'debug' ||
												  m.severity === 'info'	
												? 'icon-check-circle'
												: null
							};
						})
					};
				})
			};

			healthCheckList = [datao, ...healthCheckList.filter((x) => x.circuit != datao.circuit)];
		});

		try {
			await connection.start();
			connection.send('Subscribe', 'circuitProcess');

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

	async function stop() {
		if (!browser) return;
		connection.send('Unsubscribe', 'circuitProcess');
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
	<title>Editor - Boto GP</title>
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
		<b>Editor</b> for <br />circuits
	</h1>

	<form>
		<div class="form-group">
			<input class="form-control form-control-lg" placeholder="Filter for circuit here..." type="text" bind:value={circuitFilter} />
		</div>
	  </form>

	<div class="container">
		{#each filteredHealthCheckList as h}
			<hr />
			<h3>{h.circuit} <small>{h.oeId}</small></h3>

			<div class="row mt-2">
				{#each h.applicationLogs as a}
					<div class="card w-25 p-2">
						<h5 class="card-header">
							{#if a.messages.find((x) => x.severity === 'critical' || x.severity === 'error')}
								<span style="float:right;color:red;">&#10008;</span>
							{:else}
								<span style="float:right;">&#10004;</span>
							{/if}
							{a.applicationName} <small> - {a.time} ms</small>
						</h5>
						<div class="card-body">
							<p class="card-text">{a.messages[a.messages.length - 1].message}</p>
							<ul class="list-group list-group-flush">
								{#each a.messages as m}
									<li class="list-group-item" title={m.message}>
										{#if m.icon}
											<span class="icon {m.icon}"></span>
										{/if}
										<span>
										{m.processName}
										<br /><small>{m.timestamp} ms</small>
										</span>
									</li>
								{/each}
							</ul>
						</div>
						<div class="card-footer text-muted">
							<a href="#more" class="card-link">More</a>
						</div>
					</div>
				{/each}
			</div>
		{/each}
	</div>

	<p class="text-muted">
		Last message: <strong>{lastMessage}</strong>
	</p>

	<p>
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
