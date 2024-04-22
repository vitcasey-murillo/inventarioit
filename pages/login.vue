<script setup>
definePageMeta({
	layout: "empty",
});

//Si existe ya el usuario lo manda al inicio
const user = useSupabaseUser();

if (user.value) {
	navigateTo("/activos");
}

const client = useSupabaseClient();

const accionRealizarLogin = ref(true);

const inputEmail = ref("");
const inputPassword = ref("");

async function signIn() {
	try {
		const { data, error } = await client.auth.signInWithPassword({
			email: inputEmail.value,
			password: inputPassword.value,
		});

		if (error) {
			throw error;
		} else {
			navigateTo("/");
		}
	} catch (error) {
		alert("Error: " + error.message);
	}
}

async function resetPass() {
	try {
		const { data, error } = await client.auth.resetPasswordForEmail(inputEmail.value, {
			redirectTo: "http://localhost:3000/register_newpass",
		});

		if (error) {
			throw error;
		} else {
			alert("Correo enviado!");
		}
	} catch (error) {
		alert("Error: " + error.message);
	}
}
</script>

<template>
	<section style="height: 100vh; display: flex; align-items: center; justify-content: center">
		<form class="col-8">
			<h3 v-if="accionRealizarLogin" style="text-align: center; width: 100%">Iniciar Sesión</h3>
			<h3 v-else style="text-align: center; width: 100%">Solicitar Cambio de Contraseña</h3>
			<br />
			<br />
			<!-- Email input -->
			<div class="form-outline mb-4">
				<label class="form-label" for="form2Example1">Email</label>
				<input type="email" v-model="inputEmail" class="form-control" placeholder="it@unitec.edu" />
			</div>

			<!-- Password input -->
			<div v-if="accionRealizarLogin" class="form-outline mb-4">
				<label class="form-label" for="form2Example2">Contraseña</label>
				<input type="password" v-model="inputPassword" class="form-control" @keyup.enter="signIn" placeholder="* * * * * *" />
			</div>

			<!-- 2 column grid layout for inline styling -->
			<div v-if="accionRealizarLogin" class="row mb-4">
				<div class="col d-flex justify-content-center">
					<button type="button" class="btn btn-primary btn-block col-2" @click="signIn">Entrar</button>
				</div>
			</div>

			<div v-else class="row mb-4">
				<div class="col d-flex justify-content-center">
					<button type="button" class="btn btn-primary btn-block col-2" @click="resetPass">Recuperar</button>
				</div>
			</div>

			<div class="row mb-4">
				<div v-if="accionRealizarLogin" class="col d-flex justify-content-center">
					<a href="#" @click="accionRealizarLogin = false" style="font-size: 0.8rem; font-style: italic; color: red"> Recuperar Contraseña </a>
				</div>
				<div v-else class="col d-flex justify-content-center">
					<a href="#" @click="accionRealizarLogin = true" style="font-size: 0.8rem; font-style: italic; color: green"> Iniciar Sesión </a>
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
	text-align: center;
	width: 100%;
}

input {
	text-align: center;
}

input::placeholder {
	font-style: italic;
}
</style>
