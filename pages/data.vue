<script setup>
definePageMeta({
	middleware: "auth",
});

const client = useSupabaseClient();

const info = ref([]);
const dataTotal = ref([]);

let valorInput_Marca = ref("");
let valorInput_Tipo = ref("");
let valorInput_Estado = ref("");
let valorInput_Ubicacion = ref("");

async function cargarInformacionValores() {
	const { data } = await client.from("data").select("*");

	if (data != null) {
		dataTotal.value = data.sort((a, b) => a.tipo.localeCompare(b.tipo));
		info.value = dataTotal.value;
	}
}

async function insertarEnData(valorSelect, valorInput) {
	if (valorInput == "") {
		alert("El campo de texto no puede estar vacio");
		return;
	}

	const objeto = {
		tipo: valorSelect,
		valor: valorInput,
	};

	const { error } = await client.from("data").insert(objeto);
	if (error == null) {
		cargarInformacionValores();
	} else alert(error.message);

	valorInput_Marca.value = "";
	valorInput_Tipo.value = "";
	valorInput_Estado.value = "";
	valorInput_Ubicacion.value = "";
}

async function eliminarData(id) {
	let confirmar = confirm("¿Está seguro que desea borrar el registro? \n\nEliminar un dato conlleva en que los activos que lo poseean se les limpiará ese valor.");

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
			<!-- " -->
			<i style="font-size: 0.9em; color: red">*Eliminar un dato conlleva en que los activos que lo poseean se les limpiará ese valor y no es reversible.</i>
			<br />
			<br />
			<article>
				<div>
					<h4 style="width: 100%; text-align: center">Marca</h4>
					<br />
					<div style="display: grid; grid-template-columns: 70% 30%; column-gap: 10px">
						<input type="text" class="form-control" v-model="valorInput_Marca" />
						<button role="button" class="btn btn-success" @click="insertarEnData('Marca', valorInput_Marca)">Añadir</button>
					</div>
					<br />
					<div>
						<ul v-if="dataTotal.length > 0" v-for="elemento of info.filter((x) => x.tipo == 'Marca')" class="list-unstyled">
							<li :key="elemento.id">
								<i class="bi bi-x-circle hover-bg" style="margin-right: 10px" @click="eliminarData(elemento.id)"></i>
								<span>{{ elemento.valor }}</span>
							</li>
						</ul>
						<ul v-else class="list-unstyled">
							<li><i>Cargando...</i></li>
						</ul>
					</div>
				</div>

				<div>
					<h4 style="width: 100%; text-align: center">Tipo</h4>
					<br />
					<div style="display: grid; grid-template-columns: 70% 30%; column-gap: 10px">
						<input type="text" class="form-control" v-model="valorInput_Tipo" />
						<button role="button" class="btn btn-success" @click="insertarEnData('Tipo', valorInput_Tipo)">Añadir</button>
					</div>
					<br />
					<div>
						<ul v-if="dataTotal.length > 0" v-for="elemento of info.filter((x) => x.tipo == 'Tipo')" class="list-unstyled">
							<li :key="elemento.id">
								<i class="bi bi-x-circle hover-bg" style="margin-right: 10px" @click="eliminarData(elemento.id)"></i>
								<span>{{ elemento.valor }}</span>
							</li>
						</ul>
						<ul v-else class="list-unstyled">
							<li><i>Cargando...</i></li>
						</ul>
					</div>
				</div>

				<div>
					<h4 style="width: 100%; text-align: center">Estado</h4>
					<br />
					<div style="display: grid; grid-template-columns: 70% 30%; column-gap: 10px">
						<input type="text" class="form-control" v-model="valorInput_Estado" />
						<button role="button" class="btn btn-success" @click="insertarEnData('Estado', valorInput_Estado)">Añadir</button>
					</div>
					<br />
					<div>
						<ul v-if="dataTotal.length > 0" v-for="elemento of info.filter((x) => x.tipo == 'Estado')" class="list-unstyled">
							<li :key="elemento.id">
								<i class="bi bi-x-circle hover-bg" style="margin-right: 10px" @click="eliminarData(elemento.id)"></i>
								<span>{{ elemento.valor }}</span>
							</li>
						</ul>
						<ul v-else class="list-unstyled">
							<li><i>Cargando...</i></li>
						</ul>
					</div>
				</div>

				<div>
					<h4 style="width: 100%; text-align: center">Ubicación</h4>
					<br />
					<div style="display: grid; grid-template-columns: 70% 30%; column-gap: 10px">
						<input type="text" class="form-control" v-model="valorInput_Ubicacion" />
						<button role="button" class="btn btn-success" @click="insertarEnData('Ubicacion', valorInput_Ubicacion)">Añadir</button>
					</div>
					<br />
					<div>
						<ul v-if="dataTotal.length > 0" v-for="elemento of info.filter((x) => x.tipo == 'Ubicacion')" class="list-unstyled">
							<li :key="elemento.id">
								<i class="bi bi-x-circle hover-bg" style="margin-right: 10px" @click="eliminarData(elemento.id)"></i>
								<span>{{ elemento.valor }}</span>
							</li>
						</ul>
						<ul v-else class="list-unstyled">
							<li><i>Cargando...</i></li>
						</ul>
					</div>
				</div>
				<div style="flex-grow: 1; flex-shrink: 0; padding: 0px 30%"></div>
			</article>
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

article {
	width: 100%;
	display: flex;
	flex-direction: row;
	align-items: flex-start;
	justify-content: flex-start;
	flex-wrap: wrap;
	gap: 15px;
}

article > div {
	flex-grow: 1;
	flex-shrink: 0;
	padding: 20px;
	box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;
}
</style>
