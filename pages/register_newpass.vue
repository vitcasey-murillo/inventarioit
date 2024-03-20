<script setup>
definePageMeta({
	layout: "empty",
});

const client = useSupabaseClient();

const password = ref("");

async function updatePass() {
	try {
		const { data, error } = await client.auth.updateUser({
			password: password.value,
		});

		if (error) {
			throw error;
		} else {
			navigateTo("/");
		}
	} catch (ex) {
		alert("Error: " + ex.message);
	}
}
</script>
<template>
	<section style="height: 100vh; display: flex; align-items: center; justify-content: center">
		<form class="col-8">
			<h3 style="text-align: center; width: 100%">Cambiar contraseña</h3>
			<br />
			<br />

			<!-- Password input -->
			<div class="form-outline mb-4">
				<label class="form-label" for="form2Example2">Nueva Contraseña</label>
				<input type="password" v-model="password" class="form-control" placeholder="* * * * * *" />
			</div>

			<!-- 2 column grid layout for inline styling -->
			<div class="row mb-4">
				<div class="col d-flex justify-content-center">
					<button type="button" class="btn btn-primary btn-block col-2" @click="updatePass">Cambiar</button>
				</div>
			</div>
			<div style="position: absolute; left: 0; bottom: 0">
				<span> Creado por: W.VcM </span>
			</div>
		</form>
	</section>
</template>

<style>
label {
	width: 100%;
	text-align: center;
}

input {
	text-align: center;
}
</style>
