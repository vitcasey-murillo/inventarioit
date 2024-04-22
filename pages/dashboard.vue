<script setup>
definePageMeta({
	middleware: "auth",
});



import TipoEquipo from "~/components/graficas/TipoEquipo.vue";
import ubicacionEquipos from "~/components/graficas/UbicacionEquipos.vue";
import UsoMarca from "~/components/graficas/UsoMarca.vue";


let activosTotales = ref([]);

const client = useSupabaseClient();


async function cargarInformacionValores() {
	const { data } = await client.from("activo").select("*");

	if (data != null) {
		activosTotales.value = data;
	}
}


</script>

<template>
	<div style="width: 100%">
		<br />

		<div style="display: grid; grid-template-columns: 40% 60%">
			<div style="height: 100%; display: flex; align-items: center; justify-content: flex-start; padding: 2%"><h3>Equipos por Ubicación</h3></div>
			<ubicacionEquipos :activosTotales="activosTotales" />
		</div>

		<br />
		<div style="width: 100%; border-bottom: 1px solid gray"></div>
		<br />

		<div style="display: grid; grid-template-columns: 55% 45%">
			<div style="display: flex; align-items: center; justify-content: center">
				<UsoMarca :activosTotales="activosTotales" />
			</div>
			<div style="height: 100%; display: flex; align-items: center; justify-content: flex-start">
				<h3>Marcas Usadas en las Instalaciones</h3>
			</div>
		</div>

		<br />
		<div style="width: 100%; border-bottom: 1px solid gray"></div>
		<br />

		<div style="display: grid; grid-template-columns: 40% 60%">
			<div style="height: 100%; display: flex; align-items: center; justify-content: flex-start; padding: 2%"><h3>Distribución de Tipo</h3></div>
			<TipoEquipo :activosTotales="activosTotales" />
		</div>
	</div>
</template>
