<script setup>
definePageMeta({
	middleware: "auth",
});

const client = useSupabaseClient();

const dataTotal = ref([]);

const idMantenimientoMostrado = ref(0);

async function cargarInformacionValores() {
	const { data } = await client.from("vw_mantenimientos_cantidades").select("*");

	if (data != null) {
		dataTotal.value = data.sort((a, b) => b.id - a.id);
	}
}

function seleccionar(id) {
	idMantenimientoMostrado.value = id;

	var myModal = new bootstrap.Modal(document.getElementById("exampleModal2"), {
		keyboard: false,
	});
	myModal.show();
}

async function eliminar(id) {
	if (!await controlModalConfirmar("¿Está seguro que desea eliminar este registro?")) {
		return;
	}

	let regParaEliminar = dataTotal.value.find((x) => x.id == id);
	let eliminarActivos = false;
	let msgDescarte = `Está eliminando un Descarte: \n \npresione 'Aceptar' para eliminarel Registro y los activos \npresone 'Cancelar' para eliminar el Registro, pero mantener los activos`;

	if (regParaEliminar.tipo == "Descarte") {
		eliminarActivos = confirm(msgDescarte);
	}

	if (eliminarActivos) {
		const { data, error } = await client.rpc("eliminar_activos_por_mantenimiento", { p_idmantenimiento: id });

		if (error) console.error("Error eliminando activos:", error);
		else console.log("Activos eliminados:", data);
	}

	const { error } = await client.from("mantenimiento").delete().match({ id });
	if (error == null) {
		setTimeout(async () => {
			await controlModal("Registro Eliminado!", "success");
			cargarInformacionValores();
		}, 0);
	} else await controlModal(error.message);
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
	titulo: "Modificar",
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
				<p class="text-center" style="width: 100%">HISTORIAL</p>
			</div>
		</nav>

		<table class="table table-striped table-bordered">
			<thead>
				<tr>
					<th class="col-1">Fecha</th>
					<th class="col-2">Tipo</th>
					<th class="col-6">Descripción</th>
					<th class="col-1">Cantidad</th>
					<th class="col-2">Opciones</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="registro in dataTotal">
					<td class="col-1">{{ registro.fecha }}</td>
					<td class="col-2">{{ registro.tipo }}</td>
					<td class="col-6">{{ registro.descripcion }}</td>
					<td class="col-1">{{ registro.cantidad }}</td>
					<td class="col-2" style="width: 100%; display: flex; justify-content: space-around">
						<button class="btn btn-info" @click="seleccionar(registro.id)">Seleccionar</button>
						<button class="btn btn-danger" @click="eliminar(registro.id)">Eliminar</button>
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
