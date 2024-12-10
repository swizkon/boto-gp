const env = import.meta.env;

const baseUrl = env.PROD ? '' : 'https://localhost:5001';

export function formatUrl(path) {
	return `${baseUrl}${path}`;
}
