<script setup lang="ts">
const client = useSupabaseClient();

const email = ref("");
const password = ref("");
const errMsg = ref("");
const sccMsg = ref("");

async function signUp() {
	try {
		const { data, error } = await client.auth.signUp({
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
	<div>saludos desde register</div>
</template>
