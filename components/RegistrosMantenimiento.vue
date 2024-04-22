import type { mergeProps } from 'vue';
<script setup>
import { DataTable } from "~/DataTableImports";
const client = useSupabaseClient();

const props = defineProps({
	idMantenimiento: Number,
});

const checkColumnaOpciones = ref(true);
const checkRegistrosDescartes = ref(true);

let activosTotales = [];
const activosMostrados = ref([]);

const columnas = [
	{ title: "Marca", data: "marca" },
	{ title: "Modelo", data: "modelo" },
	{ title: "Serial", data: "serial" },
	{ title: "Tipo", data: "tipo" },
	{ title: "DiscoDuro", data: "discoDuro" },
	{ title: "Ram", data: "ram" },
	{ title: "Procesador", data: "procesador" },
	{ title: "Ubicacion", data: "ubicacion" },
	{ title: "Estado", data: "estado" },
];

const infoInventario = ref({});

async function cargarInformacionGeneral() {
	const { data } = await client.from("mantenimiento").select("*").eq("id", props.idMantenimiento);
	if (data != null) {
		infoInventario.value = data[0];
	}
}

async function cargarInformacionValores() {
	const { data } = await client.from("desglose_mantenimiento").select("*").eq("idMantenimiento", props.idMantenimiento);

	if (data != null) {
		activosTotales = data;
		activosMostrados.value = data;
	}
}
if (props.idMantenimiento != 0) {
	cargarInformacionGeneral();
	cargarInformacionValores();
}
</script>

<template>
	<div class="modal-header">
		<h5 class="modal-title" id="exampleModalLabel">
			Detalle de Mantenimiento: <br />
			{{ !!infoInventario ? `${infoInventario.tipo} - ${infoInventario.descripcion}` : "" }}
		</h5>
		<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	</div>
	<div class="modal-body">
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
					{ title: 'Mantenimiento IT', extend: 'excelHtml5' },
					{ title: 'Mantenimiento IT', extend: 'print' },
				],
			}"
		>
		</DataTable>
	</div>
	<div class="modal-footer d-flex justify-content-around">
		<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
	</div>
</template>

<style scoped></style>
