<script setup>
definePageMeta({
	middleware: "auth",
});



</script>

<template>

	<div style="width: 100%" v-if="false">
		<h3 style="width: 100%; text-align: center;">Cargando...</h3>
	</div>
	<div style="width: 100%" class="bg-sub-tema" v-else>
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div class="container-fluid">
				<p class="text-center" style="width: 100%">REPORTES</p>
			</div>
		</nav>

		
		
	</div>
</template>


<style scoped>

	.nav-link {
		color: #6e707e;
		background-color: unset !important;
	}

	.nav-link.active {
		color: black !important;
		border-bottom: 1px solid black !important;
	}

	.espacio-tab{
		width: 100%;
		padding: 5vh 0px;
	}
</style>