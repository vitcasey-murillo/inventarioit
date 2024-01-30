<script setup>
let saludo = "Hola Vit";

function saludar() {
	alert("Hola Mundo");
}
</script>

<template>
	<div style="width: 100%">
		<h3>asdasdasd</h3>
		<button class="btn btn-primary" @click="saludar">presionar</button>
		<br />
		<br />
		<input type="text" class="form-control" style="width: 400px" />
		{{ saludo }}
	</div>
</template>
