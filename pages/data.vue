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
		await controlModal("El campo de texto no puede estar vacio");
		return;
	}

	const objeto = {
		tipo: valorSelect,
		valor: valorInput,
	};

	const { error } = await client.from("data").insert(objeto);
	if (error == null) {
		cargarInformacionValores();
	} else await controlModal(error.message);

	valorInput_Marca.value = "";
	valorInput_Tipo.value = "";
	valorInput_Estado.value = "";
	valorInput_Ubicacion.value = "";
}

async function eliminarData(id) {
	console.log("intenta eliminar id", id)
	let confirmar = await controlModalConfirmar("¿Está seguro que desea borrar el registro? \n\nEliminar un dato conlleva en que los activos que lo posean se les quitará ese valor.");

	if (confirmar) {
		const { error } = await client.from("data").delete().eq("id", id);
		cargarInformacionValores();
	}
}


cargarInformacionValores();


const visualizarPanel = ref("");

function obtenerClase(enlace){
	if(enlace == visualizarPanel.value)	return "nav-link active";
	
	return "nav-link";
}

function cambiarPanel(enlace){
	visualizarPanel.value = enlace;
}

// CONTROL MODALES

async function controlModal(mensaje, tipo = "danger"){
	return new Promise((resolve)=>{

		controlAlert.value.accion = ()=>{
			controlAlert.value.visulizar = false;	
			resolve();		
		};

		controlAlert.value.tipo = tipo;
		controlAlert.value.mensaje = mensaje;
		controlAlert.value.visulizar = true;
	});
}

async function controlModalConfirmar(mensaje){
	return new Promise((resolve)=>{

		controlConfirm.value.accion = (respuesta)=>{
			controlConfirm.value.visulizar = false;	
			resolve(respuesta);		
		};

		controlConfirm.value.mensaje = mensaje;
		controlConfirm.value.visulizar = true;
	});
}


const controlAlert = ref({
	visulizar: false,
	tipo: "danger",
	titulo: "Data",
	mensaje: "",
	accion: ()=>{}
});

const controlConfirm = ref({
	visulizar: false,
	tipo: "danger",
	titulo: "Confirmar",
	mensaje: "",
	accion: ()=>{}
});

</script>
<template>
	<ModalAlert :tipo="controlAlert.tipo" :titulo="controlAlert.titulo" :mensaje="controlAlert.mensaje" :accion="controlAlert.accion" v-if="controlAlert.visulizar"/>
	<ModalConfirm :titulo="controlConfirm.titulo" :mensaje="controlConfirm.mensaje" :accion="controlConfirm.accion" v-if="controlConfirm.visulizar"/>


	<div style="width: 100%" class="bg-sub-tema">
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div class="container-fluid">
				<p class="text-center" style="width: 100%">DATA</p>
			</div>
		</nav>

		
		<i style="font-size: 0.9em; color: red">*Eliminar un dato conlleva en que los activos que lo posean se les quitará ese valor y no es reversible.</i>
		<br />

		<div class="container" style="width: 100%; margin: 0;">

			<ul class="nav nav-tabs">
				<li class="nav-item">
					<a :class="obtenerClase('marca')" href="#" @click="cambiarPanel('marca')">Gestionar: Marca</a>
				</li>
				<li class="nav-item">
					<a :class="obtenerClase('tipo')" href="#" @click="cambiarPanel('tipo')">Gestionar: Tipo</a>
				</li>
				<li class="nav-item">
					<a :class="obtenerClase('estado')" href="#" @click="cambiarPanel('estado')">Gestionar: Estado</a>
				</li>
				<li class="nav-item">
					<a :class="obtenerClase('ubicacion')" href="#" @click="cambiarPanel('ubicacion')">Gestionar: Ubicación</a>
				</li>
			</ul>

					
			<article>

				<div v-if="visualizarPanel=='marca'">

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

				<div v-if="visualizarPanel=='tipo'">
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

				<div v-if="visualizarPanel=='estado'">
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
								<i v-if="!['Nuevo', 'Descarte'].includes(elemento.valor)" class="bi bi-x-circle hover-bg" style="margin-right: 10px" @click="eliminarData(elemento.id)" ></i>
								<i v-if="['Nuevo', 'Descarte'].includes(elemento.valor)" style="margin-right: 25px;"></i>
								<span>{{ elemento.valor }}</span>
							</li>
						</ul>
						<ul v-else class="list-unstyled">
							<li><i>Cargando...</i></li>
						</ul>
					</div>
				</div>

				<div v-if="visualizarPanel=='ubicacion'">
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
	align-items: center;
	justify-content: center;

	padding-top: 20px;
}

article > div {
	
	min-width: 400px; 
	padding: 20px;
	box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;
}


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
}
</style>
