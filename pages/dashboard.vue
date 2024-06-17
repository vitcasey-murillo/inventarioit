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


const visualizarPanel = ref("ubicacion");

function obtenerClase(enlace){
	if(enlace == visualizarPanel.value) return "nav-link active";
	
	return "nav-link";
}

function cambiarPanel(enlace){
	visualizarPanel.value = enlace;
}

</script>

<template>

	<div style="width: 100%" :key="activosTotales" v-if="activosTotales.length == 0">
		<h3 style="width: 100%; text-align: center;">Cargando...</h3>
	</div>
	<div style="width: 100%" class="bg-sub-tema" v-else>
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div class="container-fluid">
				<p class="text-center" style="width: 100%">DASHBOARD</p>
			</div>
		</nav>

		<ul class="nav nav-tabs">
			<li class="nav-item">
				<a :class="obtenerClase('ubicacion')" href="#" @click="cambiarPanel('ubicacion')">Equipos por Ubicación</a>
			</li>
			<li class="nav-item">
				<a :class="obtenerClase('estado')" href="#" @click="cambiarPanel('estado')">Estado de los Activos</a>
			</li>
			<li class="nav-item">
				<a :class="obtenerClase('tipo')" href="#" @click="cambiarPanel('tipo')">Distribución de Tipo</a>
			</li>
		</ul>

		<div class="espacio-tab" v-if="visualizarPanel=='ubicacion'">
			<div style="display: grid; grid-template-columns: 40% 60%">
				<div style="height: 100%; display: flex; align-items: center; justify-content: flex-start; padding: 2%">
					<h3 style="width: 100%; text-align: center;">Equipos por Ubicación</h3>
				</div>
				<ubicacionEquipos :activosTotales="activosTotales" />
			</div>
		</div>


		
		<div class="espacio-tab" v-if="visualizarPanel=='estado'">
			<div style="display: grid; grid-template-columns: 55% 45%">
				<div style="display: flex; align-items: center; justify-content: center">
					<EstadoActivo :activosTotales="activosTotales" />
				</div>
				<div style="height: 100%; display: flex; align-items: center; justify-content: flex-start;">
					<h3>Estado de los Activos</h3>
				</div>
			</div>

		</div>

		
		<div class="espacio-tab" v-if="visualizarPanel=='tipo'">
			<div style="display: grid; grid-template-columns: 40% 60%">
				<div style="height: 100%; display: flex; align-items: center; justify-content: flex-start; padding: 2%">
					<h3 style="width: 100%; text-align: center;">Distribución de Tipo</h3>
				</div>
				<TipoEquipo :activosTotales="activosTotales" />
			</div>
		</div>

		
	</div>
</template>


<style scoped>

	.nav-link {
		color: #6e707e;
		background-color: unset !important;
	}

	.nav-link.active {
		color: black !important;
		border-bottom: 1px solid black !important;
	}

	.espacio-tab{
		width: 100%;
		padding: 5vh 0px;
	}
</style>