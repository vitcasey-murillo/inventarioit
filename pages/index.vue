<script setup>
import { DataTable } from "~/DataTableImports";
const client = useSupabaseClient();

const columnas = ref([]);

const checkColumnaOpciones = ref(true);
const checkRegistrosDescartes = ref(true);

let activosTotales = [];
const activosMostrados = ref([]);

let objetoActivo = {
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
};

const modificarActivo = ref({
	id: 0,
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

async function cargarInformacionValores() {
	const { data } = await client.from("activo").select("*");

	if (data != null) {
		activosTotales = data;
		activosMostrados.value = data;

		//no sé porque, pero requiere el setTimeOut
		setTimeout(() => {
			for (let btn of document.querySelectorAll("button[boton-opciones]")) {
				btn.addEventListener("click", (e) => {
					var myModal = new bootstrap.Modal(document.getElementById("exampleModal2"), {
						keyboard: false,
					});
					myModal.show();

					seleccionar(e.target.getAttribute("data"));
				});
			}
		}, 100);
	}
}

async function InsertarActivo() {
	const { error } = await client.from("activo").insert(objetoActivo);
	if (error == null) {
		setTimeout(() => {
			alert("Registro guardado!");
		}, 0);
		cargarInformacionValores();
	} else alert(error.message);
}

async function EliminarActivo() {
	console.log("modificar", modificarActivo);
	const { error } = await client.from("activo").delete().match({ id: modificarActivo.value.id });
	if (error == null) {
		setTimeout(() => {
			alert("Registro Eliminado!");
		}, 0);
		cargarInformacionValores();
	} else alert(error.message);
}

async function ActualizarActivo() {
	const { error } = await client.from("activo").update(modificarActivo.value).match({ id: modificarActivo.value.id });
	if (error == null) {
		setTimeout(() => {
			alert("Registro Actualizado!");
		}, 0);
		cargarInformacionValores();
	} else alert(error.message);
}

function seleccionar(id) {
	//por ahora nada
	modificarActivo.value = activosMostrados.value.find((x) => x.id == id);
	console.log(modificarActivo);
}

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
			{ title: "Ubicacion", data: "ubicacion" },
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
			{ title: "Procesador", data: "procesador" },
			{ title: "Ubicacion", data: "ubicacion" },
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

		<!-- Button trigger modal -->
		<button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#exampleModal1">Agregar Activo</button>

		<!-- Modal -->
		<div class="modal fade" id="exampleModal1" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">Activo</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<fieldset>
							<label for="" class="col-3">
								<span>marca:</span><br />
								<select name="marca" id="" class="form-control" v-model="objetoActivo.marca">
									<template v-for="marca of arrMarca">
										<option :value="marca">{{ marca }}</option>
									</template>
								</select>
							</label>
							<label for="" class="col-4">
								<span>modelo:</span><br />
								<input type="text" autocomplete="off" name="modelo" class="form-control" v-model="objetoActivo.modelo" placeholder="Optiplex..." />
							</label>
							<label for="" class="col-4">
								<span>serial:</span><br />
								<input type="text" autocomplete="off" name="serial" class="form-control" v-model="objetoActivo.serial" placeholder="S/N " />
							</label>
						</fieldset>
						<fieldset>
							<label for="" class="col-3">
								<span>tipo:</span><br />
								<select name="tipo" id="" class="form-control" v-model="objetoActivo.tipo">
									<template v-for="tipo of arrTipo">
										<option :value="tipo">{{ tipo }}</option>
									</template>
								</select>
							</label>
							<label for="" class="col-3">
								<span>Disco Duro:</span><br />
								<input type="text" autocomplete="off" name="discoDuro" class="form-control" v-model="objetoActivo.discoDuro" placeholder="256GB SSD" />
							</label>
							<label for="" class="col-2">
								<span>ram:</span><br />
								<input type="text" autocomplete="off" name="ram" class="form-control" v-model="objetoActivo.ram" placeholder="8GB" />
							</label>
							<label for="" class="col-3">
								<span>procesador:</span><br />
								<input type="text" autocomplete="off" name="procesador" class="form-control" v-model="objetoActivo.procesador" placeholder="i5 8va" />
							</label>
						</fieldset>
						<fieldset>
							<label class="col-1"></label>
							<label for="" class="col-5">
								<span>Ubicación:</span><br />
								<select name="ubicacion" id="" class="form-control" v-model="objetoActivo.ubicacion">
									<template v-for="ubicacion of arrUbicacion">
										<option :value="ubicacion">{{ ubicacion }}</option>
									</template>
								</select>
							</label>
							<label for="" class="col-4">
								<span>Estado:</span><br />
								<select name="estado" id="" class="form-control" v-model="objetoActivo.estado">
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
								<input type="text" autocomplete="off" name="asignado" class="form-control" v-model="objetoActivo.asignado" placeholder="Nombre Persona" />
							</label>
						</fieldset>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
						<button role="button" class="btn btn-success" style="margin-bottom: 5px" data-bs-dismiss="modal" @click="InsertarActivo">Guardar</button>
					</div>
				</div>
			</div>
		</div>

		<div class="modal fade" id="exampleModal2" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">Activo</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
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
						<button role="button" class="btn btn-danger" data-bs-dismiss="modal" @click="EliminarActivo">Eliminar</button>
						<button role="button" class="btn btn-warning" data-bs-dismiss="modal" @click="ActualizarActivo">Actualizar</button>
					</div>
				</div>
			</div>
		</div>

		<label class="col-12 d-flex m-0 justify-content-end">
			<input type="checkbox" v-model="checkColumnaOpciones" @change="mostrarOpciones()" />
			Ver Columna Opciones
		</label>
		<label class="col-12 d-flex m-0 justify-content-end">
			<input type="checkbox" v-model="checkRegistrosDescartes" @change="mostrarDescartes()" />
			Ver Descartes
		</label>
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
						{ title: 'Inventario IT', extend: 'excelHtml5' },
						{ title: 'Inventario IT', extend: 'print' },
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
