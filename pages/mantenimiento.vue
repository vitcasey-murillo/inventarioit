<script setup>
import dayjs from "dayjs";

definePageMeta({
	middleware: "auth",
});

const client = useSupabaseClient();

let dataCompleta = [];
const activos = ref([]);

let objetoMandar = ref({
	tipo: "Mantenimiento",
	descripcion: "",
	fecha: dayjs().format("YYYY-MM-DD"),
});

async function cargarInformacionValores() {
	const { data } = await client.from("activo").select("*").neq("estado", "Descarte");

	if (data != null) {
		let dataRevisada = data; //.filter((x) => x.Estado != "Descarte");
		dataRevisada = dataRevisada.map((x) => Object.assign(x, { seleccionado: false }));
		activos.value = dataRevisada;
		dataCompleta = dataRevisada;
	}
}

const campoBusqueda = ref("");

function filtrar() {
	if (campoBusqueda.value == "") {
		activos.value = dataCompleta;
	}
	for (let activo in activos.value) {
		let encontrado = dataCompleta.find((x) => x.id == activo.id);
		if (encontrado) {
			encontrado.seleccionado = activo.seleccionado;
		}
	}

	const regExpresion = new RegExp(`${campoBusqueda.value}.*`, "i");
	activos.value = dataCompleta.filter(
		(x) => regExpresion.test(x.marca) || regExpresion.test(x.modelo) || regExpresion.test(x.serial) || regExpresion.test(x.ubicacion) || regExpresion.test(x.asignado)
	);
}

async function insertarMantenimiento() {
	const activosSeleccionados = activos.value.filter((x) => x.seleccionado);

	if (activosSeleccionados.length == 0) {
		await controlModal("No se ha seleccionado ningún registro.");
		return;
	}

	const { data, error } = await client.rpc("insertar_mantenimiento_y_activos", {
		tipo_param: objetoMandar.value.tipo,
		descripcion_param: objetoMandar.value.descripcion,
		fecha_param: objetoMandar.value.fecha.toString(),
		ids_activos_param: activosSeleccionados.map((x) => x.id),
	});

	if (error) {
		await controlModal("Problemas: " + error);
	} else {
		await controlModal("Operación Realizada!", "success");
		location.reload();
	}
}

cargarInformacionValores();




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
	titulo: "Mantenimiento",
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
	


	<div style="width: 100%; padding: 5px" class="bg-sub-tema">
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div class="container-fluid">
				<p class="text-center" style="width: 100%">CREAR MANTENIMIENTO</p>
			</div>
		</nav>

		<div class="d-flex grupo-procesar">
			<div class="col-2">
				<label style="width: 100%">
					<b>Tipo De Mantenimiento</b><br />
					<select v-model="objetoMandar.tipo" class="form-control">
						<option value="Mantenimiento">Mantenimiento</option>
						<option value="Descarte">Descarte</option>
					</select>
				</label>
			</div>
			<div class="col-6">
				<b>Descripción</b><br />
				<textarea style="width: 100%" v-model="objetoMandar.descripcion"> </textarea>
			</div>
			<div class="col-2">
				<b>Fecha Realizado:</b><br />
				<input type="date" class="form-control" v-model="objetoMandar.fecha" />
			</div>
			<div class="col-2 d-flex justify-content-center align-items-center">
				<button class="btn btn-primary" @click="insertarMantenimiento">Procesar</button>
			</div>
		</div>

		<br />
		<div class="d-flex justify-content-end">
			<label class="d-flex align-items-center m-1">
				Buscar:
				<input type="text" class="form-control" style="width: 400px" v-model="campoBusqueda" @input="filtrar" placeholder="Buscar registros..." />
			</label>
		</div>
		<table class="table table-striped table-bordered">
			<thead>
				<tr>
					<th>Marca</th>
					<th>Modelo</th>
					<th>Serial</th>
					<th>Tipo</th>
					<th>Ubicación</th>
					<th>Asignado A</th>
					<th>Estado</th>
					<th>Seleccionar</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="activo in activos.slice(0, 15)">
					<td>{{ activo.marca }}</td>
					<td>{{ activo.modelo }}</td>
					<td>{{ activo.serial }}</td>
					<td>{{ activo.tipo }}</td>
					<td>{{ activo.ubicacion }}</td>
					<td>{{ activo.asignado }}</td>
					<td>{{ activo.estado }}</td>
					<td><input type="checkbox" v-model="activo.seleccionado" /></td>
				</tr>
			</tbody>
		</table>
	</div>
</template>

<style scoped>
label {
	user-select: none;
}

.grupo-procesar > div {
	padding: 5px;
}
</style>
