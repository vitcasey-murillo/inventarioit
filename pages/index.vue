<script setup>
definePageMeta({
	layout: "empty",
});

const client = useSupabaseClient();

if (client.auth.getSession()) {
	navigateTo("/activos");
}
</script>

<template>
	<section>
		<h3>Redireccionando...</h3>
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
}
div {
	color: #000;
	display: flex;
	flex-direction: column;
	row-gap: 10px;
}
</style>
