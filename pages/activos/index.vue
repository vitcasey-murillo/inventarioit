<script setup>
import { DataTable } from "~/DataTableImports";

definePageMeta({
	middleware: "auth",
});

const client = useSupabaseClient();

const columnas = ref([]);

const checkColumnaOpciones = ref(true);
const checkRegistrosDescartes = ref(true);

let activosTotales = [];
const activosMostrados = ref([]);

async function cargarInformacionValores() {
	const { data } = await client.from("activo").select("*");

	if (data != null) {
		activosTotales = data;
		activosMostrados.value = data;
	}
}

const fechaMostrar = ref("yyyy-MM-dd");

function calcularFechaActual() {
	const fechaActual = new Date();

	const año = fechaActual.getFullYear();
	const mes = fechaActual.getMonth() + 1; // getMonth() devuelve un valor de 0 a 11, así que sumamos 1
	const dia = fechaActual.getDate();

	const mesFormateado = mes < 10 ? `0${mes}` : mes;
	const diaFormateado = dia < 10 ? `0${dia}` : dia;

	const fechaFormateada = `${año}-${mesFormateado}-${diaFormateado}`;
	fechaMostrar.value = fechaFormateada;
}
calcularFechaActual();

function seleccionar(id) {
	//por ahora nada
	navigateTo("/activos/modificar/?idActivo=" + id);
}

onMounted(() => {
	document.addEventListener("click", (e) => {
		if (e.target.hasAttribute("boton-opciones")) {
			//detecta solo los boton opciones
			seleccionar(e.target.getAttribute("data"));
		}
	});
});

function renderizarBotones(row) {
	return `<div style="text-align:center"><button class="btn btn-info" boton-opciones data=${row.id}>Seleccionar</button></div>`;
}

function mostrarOpciones() {
	if (checkColumnaOpciones.value) {
		columnas.value = [
			{ title: "Marca", data: "marca" },
			{ title: "Modelo", data: "modelo" },
			{ title: "Serial", data: "serial" },
			{ title: "Tipo", data: "tipo" },
			{ title: "Ubicación", data: "ubicacion" },
			{ title: "Asignado A", data: "asignado" },
			{ title: "Estado", data: "estado" },
			{
				title: "Opciones",
				data: null,
				render: function (data, type, row) {
					return renderizarBotones(row);
				},
			},
		];
	} else {
		columnas.value = [
			{ title: "Marca", data: "marca" },
			{ title: "Modelo", data: "modelo" },
			{ title: "Serial", data: "serial" },
			{ title: "Tipo", data: "tipo" },
			{ title: "DiscoDuro", data: "discoDuro" },
			{ title: "Ram", data: "ram" },
			{ title: "Ubicacion", data: "ubicacion" },
			{ title: "Asignado A", data: "asignado" },
			{ title: "Estado", data: "estado" },
		];
	}
}
mostrarOpciones();

function mostrarDescartes() {
	if (checkRegistrosDescartes.value) {
		activosMostrados.value = activosTotales;
	} else {
		activosMostrados.value = activosTotales.filter((x) => x.estado != "Descarte");
	}
}

cargarInformacionValores();
</script>
<template>
	<div style="width: 100%; padding: 5px">
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div class="container-fluid">
				<p class="text-center" style="width: 100%">ACTIVOS</p>
			</div>
		</nav>

		<NuxtLink class="btn btn-success" href="/activos/agregar">Agregar Activo</NuxtLink>

		<div class="col-12 d-flex" style="justify-content: flex-end; align-items: flex-end; flex-direction: column">
			<label style="width: fit-content">
				<input type="checkbox" v-model="checkColumnaOpciones" @change="mostrarOpciones()" />
				Ver Columna Opciones
			</label>
			<label style="width: fit-content">
				<input type="checkbox" v-model="checkRegistrosDescartes" @change="mostrarDescartes()" />
				Ver Registros Descarte
			</label>
		</div>
		<div class="table-responsive" style="padding: 10px">
			<DataTable
				id="tablaactivos"
				:key="columnas"
				:data="activosMostrados"
				:columns="columnas"
				class="table dataTable table-striped table-bordered"
				style="width: 100%"
				:options="{
					pageLength: 8,
					responsive: true,
					autoWidth: false,
					language: {
						searchPlaceholder: 'Buscar Registros...',
					},
					dom: 'Bfrtip',
					buttons: [
						{ title: `Inventario IT - ${fechaMostrar}`, extend: 'excelHtml5' },
						{ title: `Inventario IT - ${fechaMostrar}`, extend: 'print' },
					],
				}"
			>
			</DataTable>
		</div>
	</div>
</template>

<style>
@import "datatables.net-bs5";

*::placeholder {
	color: lightgray !important;
	font-style: italic;
	text-align: center;
}

label,
button {
	margin: 0px 1px;
}

label > * {
	font-size: 13px;
}

/*Cambios forzados para La tabla de DataTable */
.dt-buttons {
	margin: 10px !important;
}
#DataTables_Table_0_filter label {
	padding: 10px !important;
}
input[type="search"] {
	width: 400px !important;
}
</style>
