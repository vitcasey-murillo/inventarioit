<script setup>
definePageMeta({
	layout: "empty",
});
</script>

<template>
	<section>
		<h3>Luego incorporar redireccion automatica por sesion</h3>

		<div>
			<NuxtLink href="/activos">Inicio</NuxtLink>
			<NuxtLink href="/login">Login</NuxtLink>
		</div>
	</section>
</template>

<style scoped>
section {
	width: 100%;
	min-height: 90vh;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	row-gap: 20px;
}
div {
	color: #000;
	display: flex;
	flex-direction: column;
	row-gap: 10px;
}

a {
	text-decoration: none;
}
</style>
