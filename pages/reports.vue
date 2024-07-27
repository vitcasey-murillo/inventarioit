<script setup>
definePageMeta({
	middleware: "auth",
});

let activosTotales = ref([]);
const client = useSupabaseClient();

import ReporteFiltrado from '~/components/reportes/ReporteFiltrado.vue';

const opcionesUbicacion = ref([]);
const filtroUbicacion = ref("");
const activosFiltradosPorUbicacion = ref([]);
function filtroUb(){
	const res = filtroUbicacion.value == "--Todos--"? activosTotales.value : activosTotales.value.filter((x)=> x.ubicacion == filtroUbicacion.value)
	
	activosFiltradosPorUbicacion.value = Array.from(res.map((x)=> JSON.parse(JSON.stringify(x)) )); 
}



const opcionesPersona = ref([]);
const filtroPersona = ref("");
const activosFiltradosPorPersona = ref([]);
function filtroPer(){
	const res = filtroPersona.value == "--Todos--"? activosTotales.value : activosTotales.value.filter((x)=> x.asignado == filtroPersona.value)
	
	activosFiltradosPorPersona.value = Array.from(res.map((x)=> JSON.parse(JSON.stringify(x)) )); 
}



const opcionesTipo = ref([]);
const filtroTipo = ref("");
const opcionesMarca = ref([]);
const filtroMarca = ref("");
const activosFiltradosPorTipo = ref([]);
function filtroTip(){
	let res = filtroTipo.value == "--Todos--"? activosTotales.value : activosTotales.value.filter((x)=> x.tipo == filtroTipo.value)
	
	res = filtroMarca.value == "--Todos--" || filtroMarca.value == "" ? res : res.value.filter((x)=> x.marca == filtroMarca.value)

	activosFiltradosPorTipo.value = Array.from(res.map((x)=> JSON.parse(JSON.stringify(x)) )); 
}




async function cargarInformacionValores() {
	const { data } = await client.from("activo").select("*");

	if (data != null) {
		activosTotales.value = data;

		//cargar filtro 1
		let arrUbicaciones = activosTotales.value.map((x) => x.ubicacion).reduce((acc, act) => {
			if (!acc.includes(act)) {
				acc.push(act);
			}
			return acc;
		}, []);

		opcionesUbicacion.value = ["--Todos--"].concat(arrUbicaciones);


		//cargar filtro 2
		let arrPersonas = activosTotales.value.map((x) => x.asignado).reduce((acc, act) => {
			if (!acc.includes(act)) {
				acc.push(act);
			}
			return acc;
		}, []);

		opcionesPersona.value = ["--Todos--"].concat(arrPersonas);


		//cargar filtro 3
		let arrTipo = activosTotales.value.map((x) => x.tipo).reduce((acc, act) => {
			if (!acc.includes(act)) {
				acc.push(act);
			}
			return acc;
		}, []);

		opcionesTipo.value = ["--Todos--"].concat(arrTipo);


		//cargar filtro 3.1
		let arrMarca = activosTotales.value.map((x) => x.marca).reduce((acc, act) => {
			if (!acc.includes(act)) {
				acc.push(act);
			}
			return acc;
		}, []);

		opcionesMarca.value = ["--Todos--"].concat(arrMarca);

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
				<p class="text-center" style="width: 100%">Reportes</p>
			</div>
		</nav>

		<ul class="nav nav-tabs">
			<li class="nav-item">
				<a :class="obtenerClase('ubicacion')" href="#" @click="cambiarPanel('ubicacion')">Equipos Por Ubicación</a>
			</li>
			<li class="nav-item">
				<a :class="obtenerClase('persona')" href="#" @click="cambiarPanel('persona')">Equipos Asignanos a Una Persona</a>
			</li>
			<li class="nav-item">
				<a :class="obtenerClase('tipo')" href="#" @click="cambiarPanel('tipo')">Equipos por Tipo</a>
			</li>
		</ul>

		<div class="espacio-tab" v-if="visualizarPanel=='ubicacion'">
			<h3>Seleccionar Ubicación:</h3>
			<label style="width: 30%">
				<select v-model="filtroUbicacion" @change="filtroUb" class="form-control">
					<template v-for="ubicacion of opcionesUbicacion">
						<option :value="ubicacion">{{ ubicacion }}</option>
					</template>
				</select>
			</label>

			<ReporteFiltrado :key="filtroUbicacion" :activos-mostrados="activosFiltradosPorUbicacion" />
		</div>


		
		<div class="espacio-tab" v-if="visualizarPanel=='persona'">
			<h3>Seleccionar Responsable:</h3>
			<label style="width: 30%">
				<select v-model="filtroPersona" @change="filtroPer" class="form-control">
					<template v-for="persona of opcionesPersona">
						<option :value="persona">{{ persona }}</option>
					</template>
				</select>
			</label>

			<ReporteFiltrado :key="filtroPersona" :activos-mostrados="activosFiltradosPorPersona" />
		</div>



		
		
		<div class="espacio-tab" v-if="visualizarPanel=='tipo'">
			<div style="display: grid; grid-template-columns: 30% 30%; column-gap: 10%;">
				<div>
					<h3>Seleccionar Tipo Dispositivo:</h3>
					<label style="width: 80%">
					<select v-model="filtroTipo" @change="filtroTip" class="form-control">
						<template v-for="tipo of opcionesTipo">
							<option :value="tipo">{{ tipo }}</option>
						</template>
					</select>
				</label>
				</div>

				<div>
					<h3>Seleccionar Marca:</h3>
					<label style="width: 80%">
					<select v-model="filtroMarca" @change="filtroTip" class="form-control">
						<template v-for="marca of opcionesMarca">
							<option :value="marca">{{ marca }}</option>
						</template>
					</select>
				</label>
				</div>

			</div>

			<ReporteFiltrado :key="filtroTipo" :activos-mostrados="activosFiltradosPorTipo" />
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