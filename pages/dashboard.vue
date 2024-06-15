<script setup>
definePageMeta({
	middleware: "auth",
});



import TipoEquipo from "~/components/graficas/TipoEquipo.vue";
import ubicacionEquipos from "~/components/graficas/UbicacionEquipos.vue";
import EstadoActivo from "~/components/graficas/EstadoActivo.vue";


let activosTotales = ref([]);

const client = useSupabaseClient();


async function cargarInformacionValores() {
	const { data } = await client.from("activo").select("*");

	if (data != null) {
		activosTotales.value = data;
	}
}


cargarInformacionValores();

</script>

<template>

	<div style="width: 100%" :key="activosTotales" v-if="activosTotales.length == 0">
		<h3 style="width: 100%; text-align: center;">Cargando...</h3>
	</div>
	<div style="width: 100%" v-else>
			<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div class="container-fluid">
				<p class="text-center" style="width: 100%">DASHBOARD</p>
			</div>
		</nav>
		<div style="display: grid; grid-template-columns: 40% 60%">
			<div style="height: 100%; display: flex; align-items: center; justify-content: flex-start; padding: 2%"><h3>Equipos por ubicación</h3></div>
			<ubicacionEquipos :activosTotales="activosTotales" />
		</div>

		<br />
		<div style="width: 100%; border-bottom: 1px solid gray"></div>
		<br />

		<div style="display: grid; grid-template-columns: 55% 45%">
			<div style="display: flex; align-items: center; justify-content: center">
				<EstadoActivo :activosTotales="activosTotales" />
			</div>
			<div style="height: 100%; display: flex; align-items: center; justify-content: flex-start">
				<h3>Estado de los Activos</h3>
			</div>
		</div>

		<br />
		<div style="width: 100%; border-bottom: 1px solid gray"></div>
		<br />

		<div style="display: grid; grid-template-columns: 40% 60%">
			<div style="height: 100%; display: flex; align-items: center; justify-content: flex-start; padding: 2%"><h3>Distribución de tipo </h3></div>
			<TipoEquipo :activosTotales="activosTotales" />
		</div>
	</div>
</template>
