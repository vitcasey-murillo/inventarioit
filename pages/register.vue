<script setup lang="ts">
const client = useSupabaseClient();

const email = ref("");
const password = ref("");
const errMsg = ref("");
const sccMsg = ref("");

async function signUp() {
	try {
		const { data, error } = await client.auth.signInWithPassword({
			email: email.value,
			password: password.value,
		});

		if (error) throw error;
		sccMsg.value = "Check your email to confirm your account.";
	} catch (error: any) {
		errMsg.value = error.messsage;
	}
}
</script>
<template>
	<section style="height: 100vh; display: flex; align-items: center; justify-content: center">
		<form class="col-8">
			<h3 style="text-align: center; width: 100%">Iniciar Sesión</h3>
			<br />
			<br />
			<!-- Email input -->
			<div class="form-outline mb-4">
				<label class="form-label" for="form2Example1">Email address</label>
				<input type="email" id="form2Example1" class="form-control" placeholder="it@unitec.edu" />
			</div>

			<!-- Password input -->
			<div class="form-outline mb-4">
				<label class="form-label" for="form2Example2">Password</label>
				<input type="password" id="form2Example2" class="form-control" placeholder="* * * * * *" />
			</div>

			<!-- 2 column grid layout for inline styling -->
			<div class="row mb-4">
				<div class="col d-flex justify-content-center">
					<button type="button" class="btn btn-primary btn-block col-1" @click="signUp">Entrar</button>
				</div>
			</div>
			<div style="position: absolute; left: 0; bottom: 0">
				<span> Creado por: W.VcM </span>
			</div>
		</form>
	</section>
</template>
