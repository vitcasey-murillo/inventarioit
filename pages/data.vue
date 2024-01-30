<script setup>
const client = useSupabaseClient();

const info = ref([]);
const dataTotal = ref([]);

let valorSelect = "";
let valorInput = "";

async function cargarInformacionValores() {
	const { data } = await client.from("data").select("*");

	console.log("data", data);
	if (data != null) {
		dataTotal.value = data.sort((a, b) => a.tipo.localeCompare(b.tipo));
		info.value = dataTotal.value;
	}
}

async function insertarEnData() {
	if (valorSelect == "") {
		alert("Debe seleccionar un elemento de la Lista para poder Insertar");
		document.getElementById("select_Tipos").focus();
		return;
	}

	const objeto = {
		tipo: valorSelect,
		valor: valorInput,
	};

	const { error } = await client.from("data").insert(objeto);
	if (error == null) {
		valorInput = "";
		cargarInformacionValores();
	} else alert(error.message);
}

async function eliminarData(id) {
	let confirmar = confirm("¿Está seguro que desea borrar el registro?");

	if (confirmar) {
		const { error } = await client.from("data").delete().eq("id", id);
		cargarInformacionValores();
	}
}

async function filtrarValores() {
	info.value = dataTotal.value.filter((x) => x.tipo == valorSelect);
}

cargarInformacionValores();
</script>
<template>
	<div style="width: 100%">
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div class="container-fluid">
				<p class="text-center" style="width: 100%">DATA</p>
			</div>
		</nav>

		<div class="container" style="padding: 50px">
			<div class="row col-6">
				<label for="select_Tipos">Lista de Tipos</label>
				<select name="" id="select_Tipos" class="form-control" v-model="valorSelect" @change="filtrarValores">
					<option value="Marca">Marca</option>
					<option value="Ubicacion">Ubicacion</option>
					<option value="Condicion">Condicion</option>
				</select>
			</div>
			<br />
			<div class="row">
				<ul v-if="dataTotal.length > 0" v-for="elemento of info" class="list-unstyled">
					<li :key="elemento.id">
						<i class="bi bi-x-circle hover-bg" style="margin-right: 10px" @click="eliminarData(elemento.id)"></i>
						<span>{{ elemento.tipo }}: </span>
						<span>{{ elemento.valor }}</span>
					</li>
				</ul>
				<ul v-else class="list-unstyled">
					<li><i>Cargando...</i></li>
				</ul>
			</div>
			<div class="row d-flex col-6">
				<input type="text" class="form-control" v-model="valorInput" />
				<button role="button" class="btn btn-success" @click="insertarEnData">Añadir</button>
			</div>
		</div>

		<!-- Add your content here -->
	</div>
</template>

<style scoped>
.hover-bg {
	margin-right: 10px;
	border-radius: 100px;
}
.hover-bg:hover {
	background-color: #ffdddd; /* Un tono claro de rojo */
}
</style>
