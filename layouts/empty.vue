<script setup></script>

<template>
	<Head>
		<title>Inventario IT</title>

		<Link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" crossorigin="anonymous" />

		<Script
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
			integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
			crossorigin="anonymous"
		></Script>
	</Head>
	<div>
		<slot />
	</div>
</template>

<style>
body {
	background-color: #f8f9fa;
}
</style>
