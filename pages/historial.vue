<script setup>
definePageMeta({
	middleware: "auth",
});

const client = useSupabaseClient();

const info = ref([]);
const dataTotal = ref([]);

let valorSelect = "";
let valorInput = "";

const idMantenimientoMostrado = ref(0);

async function cargarInformacionValores() {
	const { data } = await client.from("vw_mantenimientos_cantidades").select("*");

	console.log("data", data);
	if (data != null) {
		dataTotal.value = data.sort((a, b) => a.tipo.localeCompare(b.tipo));
		info.value = dataTotal.value;
	}
}

function seleccionar(id) {
	idMantenimientoMostrado.value = id;

	console.log("idMantenimientoMostrado", idMantenimientoMostrado.value);
	var myModal = new bootstrap.Modal(document.getElementById("exampleModal2"), {
		keyboard: false,
	});
	myModal.show();

	//cambiarData
}

cargarInformacionValores();
</script>

<template>
	<div style="width: 100%">
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div class="container-fluid">
				<p class="text-center" style="width: 100%">HISTORIAL</p>
			</div>
		</nav>

		<table class="table table-striped table-bordered">
			<thead>
				<tr>
					<th class="col-2">Fecha</th>
					<th class="col-2">Tipo</th>
					<th class="col-6">Descripción</th>
					<th class="col-1">Cant.</th>
					<th class="col-1">Opciones</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="registro in dataTotal">
					<td class="col-2">{{ registro.fecha }}</td>
					<td class="col-2">{{ registro.tipo }}</td>
					<td class="col-6">{{ registro.descripcion }}</td>
					<td class="col-1">{{ registro.cantidad }}</td>
					<td class="col-1">
						<button class="btn btn-info" @click="seleccionar(registro.id)">Seleccionar</button>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="modal fade" id="exampleModal2" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-fullscreen">
			<div class="modal-content">
				<RegistrosMantenimiento :id-mantenimiento="idMantenimientoMostrado" :key="idMantenimientoMostrado" />
			</div>
		</div>
	</div>
</template>

<style scoped></style>
