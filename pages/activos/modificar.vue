<script setup>
definePageMeta({
	middleware: "auth",
});

const client = useSupabaseClient();

const dominioUniversitario = "@unitec.edu.hn";


const params = new URLSearchParams(location.search);
const idActivo = parseInt("" + params.get("idActivo"));

const modificarActivo = ref({
	id: idActivo,
	marca: "",
	modelo: "",
	serial: "",
	tipo: "",
	discoDuro: "",
	ram: "",
	procesador: "",
	ubicacion: "",
	estado: "",
	asignado: "",
});

let arrMarca = ref([]);
let arrUbicacion = ref([]);
let arrTipo = ref([]);
let arrEstado = ref([]);

async function cargarDataParametros() {
	const { data } = await client.from("data").select("*");

	if (data != null) {
		data.forEach((x) => {
			if (x.tipo == "Marca") arrMarca.value.push(x.valor);
			else if (x.tipo == "Ubicacion") arrUbicacion.value.push(x.valor);
			else if (x.tipo == "Tipo") arrTipo.value.push(x.valor);
			else if (x.tipo == "Estado") arrEstado.value.push(x.valor);
		});
	}
}
cargarDataParametros();

async function cargarDataActivo() {
	const { data } = await client.from("activo").select("*").match({ id: idActivo });
	modificarActivo.value = data[0];
	modificarActivo.value.asignado = modificarActivo.value.asignado.replace(dominioUniversitario, "");
}

cargarDataActivo();

async function EliminarActivo(e) {
	e.preventDefault();

	if (!confirm("Está seguro que desea eliminar este registro?")) {
		return;
	}
	const { error } = await client.from("activo").delete().match({ id: idActivo });
	if (error == null) {
		setTimeout(() => {
			alert("Registro Eliminado!");
			navigateTo("/activos");
		}, 0);
	} else alert(error.message);
}

async function ActualizarActivo(e) {
	e.preventDefault();

	if (modificarActivo.value.marca.length == 0) {
		alert("El campo 'marca' no es valido!");
		return;
	}

	if (modificarActivo.value.modelo.length == 0) {
		alert("El campo 'modelo' no es valido!");
		return;
	}

	if (modificarActivo.value.tipo.length == 0) {
		alert("El campo 'tipo' no es valido!");
		return;
	}

	if (modificarActivo.value.ubicacion.length == 0) {
		alert("El campo 'ubicacion' no es valido!");
		return;
	}

	if (modificarActivo.value.estado.length == 0) {
		alert("El campo 'estado' no es valido!");
		return;
	}

	modificarActivo.value.asignado += dominioUniversitario;
	
	console.log("modificarActivo", modificarActivo.value)
	
	const { error } = await client.from("activo").update(modificarActivo.value).match({ id: modificarActivo.value.id });
	if (error == null) {
		setTimeout(() => {
			alert("Activo Actualizado!");
			navigateTo("/activos");
		}, 0);
	} else alert(error.message);
}
</script>
<template>
	<div style="width: 100%; padding: 5px">
		<br />
		<h3 style="width: 100%; text-align: center">MODIFICAR ACTIVO</h3>

		<form action="" class="formulario">
			<div>
				<fieldset>
					<label for="" class="col-10">
						<span>Marca:</span><br />
						<select name="marca" id="" class="form-control" v-model="modificarActivo.marca" required>
							<template v-for="marca of arrMarca">
								<option :value="marca">{{ marca }}</option>
							</template>
						</select>
					</label>
					<br />
					<label for="" class="col-10">
						<span>Modelo:</span><br />
						<input type="text" autocomplete="off" name="modelo" class="form-control" v-model="modificarActivo.modelo" placeholder="Optiplex..." required />
					</label>
					<br />
					<label for="" class="col-10">
						<span>Serial:</span><br />
						<input type="text" autocomplete="off" name="serial" class="form-control" v-model="modificarActivo.serial" placeholder="S/N " />
					</label>
				</fieldset>
				<br />
				<fieldset>
					<label for="" class="col-10">
						<span>Tipo:</span><br />
						<select name="tipo" id="" class="form-control" v-model="modificarActivo.tipo" required>
							<template v-for="tipo of arrTipo">
								<option :value="tipo">{{ tipo }}</option>
							</template>
						</select>
					</label>
					<br />
					<label for="" class="col-10">
						<span>Disco Duro:</span><br />
						<input type="text" autocomplete="off" name="discoDuro" class="form-control" v-model="modificarActivo.discoDuro" placeholder="256GB SSD" />
					</label>
					<br />
					<label for="" class="col-10">
						<span>Ram:</span><br />
						<input type="text" autocomplete="off" name="ram" class="form-control" v-model="modificarActivo.ram" placeholder="8GB" />
					</label>
					<br />
					<label for="" class="col-10">
						<span>Procesador:</span><br />
						<input type="text" autocomplete="off" name="procesador" class="form-control" v-model="modificarActivo.procesador" placeholder="i5 8va" />
					</label>
				</fieldset>
			</div>

			<div style="display: flex; flex-direction: column">
				<fieldset>
					<label for="" class="col-11">
						<span>Ubicación:</span><br />
						<select name="ubicacion" id="" class="form-control" v-model="modificarActivo.ubicacion" required>
							<template v-for="ubicacion of arrUbicacion">
								<option :value="ubicacion">{{ ubicacion }}</option>
							</template>
						</select>
					</label>
					<br />
					<label for="" class="col-11">
						<span>Estado:</span><br />
						<select name="estado" id="" class="form-control" v-model="modificarActivo.estado" required>
							<template v-for="estado of arrEstado">
								<option :value="estado">{{ estado }}</option>
							</template>
						</select>
					</label>
				</fieldset>
				<br />
				<fieldset>
					<label for="" class="col-11">
						<span>Asignado A:</span><br />
						<div style="display: flex; justify-content: center;">
							<input type="email" autocomplete="off" name="asignado" class="form-control" v-model="modificarActivo.asignado" placeholder="usuario.correo" required />
							<span class="input-group-text" id="emailDomain">{{ dominioUniversitario }}</span>
						</div>
					</label>
				</fieldset>
				<br />
				<div class="col-11" style="flex: 1; display: flex; align-items: flex-end; justify-content: space-between; column-gap: 10px">
					<button role="button" class="btn btn-danger" data-bs-dismiss="modal" @click="EliminarActivo">Eliminar</button>
					<button role="button" class="btn btn-warning" data-bs-dismiss="modal" @click="ActualizarActivo">Actualizar</button>
				</div>
			</div>
		</form>
		<!--
			<form action="" class="formulario">
			<div class="modal-body">
				<fieldset>
					<label for="" class="col-3">
						<span>marca:</span><br />
						<select name="marca" id="" class="form-control" v-model="modificarActivo.marca">
							<template v-for="marca of arrMarca">
								<option :value="marca">{{ marca }}</option>
							</template>
						</select>
					</label>
					<label for="" class="col-4">
						<span>modelo:</span><br />
						<input type="text" autocomplete="off" name="modelo" class="form-control" v-model="modificarActivo.modelo" placeholder="Optiplex..." />
					</label>
					<label for="" class="col-4">
						<span>serial:</span><br />
						<input type="text" autocomplete="off" name="serial" class="form-control" v-model="modificarActivo.serial" placeholder="S/N " />
					</label>
				</fieldset>
				<fieldset>
					<label for="" class="col-3">
						<span>tipo:</span><br />
						<select name="tipo" id="" class="form-control" v-model="modificarActivo.tipo">
							<template v-for="tipo of arrTipo">
								<option :value="tipo">{{ tipo }}</option>
							</template>
						</select>
					</label>
					<label for="" class="col-3">
						<span>Disco Duro:</span><br />
						<input type="text" autocomplete="off" name="discoDuro" class="form-control" v-model="modificarActivo.discoDuro" placeholder="256GB SSD" />
					</label>
					<label for="" class="col-2">
						<span>ram:</span><br />
						<input type="text" autocomplete="off" name="ram" class="form-control" v-model="modificarActivo.ram" placeholder="8GB" />
					</label>
					<label for="" class="col-3">
						<span>procesador:</span><br />
						<input type="text" autocomplete="off" name="procesador" class="form-control" v-model="modificarActivo.procesador" placeholder="i5 8va" />
					</label>
				</fieldset>
				<fieldset>
					<label class="col-1"></label>
					<label for="" class="col-5">
						<span>Ubicación:</span><br />
						<select name="ubicacion" id="" class="form-control" v-model="modificarActivo.ubicacion">
							<template v-for="ubicacion of arrUbicacion">
								<option :value="ubicacion">{{ ubicacion }}</option>
							</template>
						</select>
					</label>
					<label for="" class="col-4">
						<span>Estado:</span><br />
						<select name="estado" id="" class="form-control" v-model="modificarActivo.estado">
							<template v-for="estado of arrEstado">
								<option :value="estado">{{ estado }}</option>
							</template>
						</select>
					</label>
				</fieldset>
				<fieldset>
					<label class="col-1"></label>
					<label for="" class="col-9">
						<span>asignado A:</span><br />
						<input type="text" autocomplete="off" name="asignado" class="form-control" v-model="modificarActivo.asignado" placeholder="Nombre Persona" />
					</label>
				</fieldset>
			</div>
			<div class="modal-footer d-flex justify-content-around">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
				
			</div>
		</form>
		--></div>
</template>

<style scoped>
@import "datatables.net-bs5";

*::placeholder {
	color: #777 !important;
	font-style: italic;
	text-align: center;
}

.formulario {
	padding: 15px;
	display: grid;
	grid-template-columns: 50% 50%;
}

@media (max-width: 900px) {
	.formulario {
		grid-template-columns: 100% !important;
	}
}

.form-control {
	border: 1px solid #555;
	padding: 8px !important;
	text-align: center;
	color: #000;
}

.form-control:invalid {
	border: 1px solid red;
	box-shadow: #f552 0px 2px 8px 0px;
}

span {
	font-weight: bold;
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
