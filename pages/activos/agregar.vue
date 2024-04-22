<script setup>
definePageMeta({
	middleware: "auth",
});

const client = useSupabaseClient();

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

async function InsertarActivo(e) {
	e.preventDefault();

	if (objetoActivo.marca.length == 0) {
		alert("El campo 'marca' no es valido!");
		return;
	}

	if (objetoActivo.modelo.length == 0) {
		alert("El campo 'modelo' no es valido!");
		return;
	}

	if (objetoActivo.tipo.length == 0) {
		alert("El campo 'tipo' no es valido!");
		return;
	}

	if (objetoActivo.ubicacion.length == 0) {
		alert("El campo 'ubicacion' no es valido!");
		return;
	}

	if (objetoActivo.estado.length == 0) {
		alert("El campo 'estado' no es valido!");
		return;
	}

	if (objetoActivo.asignado.length <= "@unitec.edu".length) {
		alert("El campo 'correo' no es valido porque parece corto!");
		return;
	}

	if (!objetoActivo.asignado.includes("@unitec.edu") && !objetoActivo.asignado.includes("@unitec.edu.hn")) {
		alert("El campo 'correo' no es valido porque no contiene un correo institucional!");
		return;
	}

	const { error } = await client.from("activo").insert(objetoActivo);
	if (error == null) {
		setTimeout(() => {
			alert("Activo Creado!");
			navigateTo("/activos");
		}, 0);
		//cargarInformacionValores();
	} else alert(error.message);
}
</script>
<template>
	<div style="width: 100%; padding: 5px">
		<br />
		<h3 style="width: 100%; text-align: center">AGREGAR ACTIVO</h3>
		<form action="" class="formulario">
			<div>
				<fieldset>
					<label for="" class="col-10">
						<span>Marca:</span><br />
						<select name="marca" id="" class="form-control" v-model="objetoActivo.marca" required>
							<template v-for="marca of arrMarca">
								<option :value="marca">{{ marca }}</option>
							</template>
						</select>
					</label>
					<br />
					<label for="" class="col-10">
						<span>Modelo:</span><br />
						<input type="text" autocomplete="off" name="modelo" class="form-control" v-model="objetoActivo.modelo" placeholder="Optiplex..." required />
					</label>
					<br />
					<label for="" class="col-10">
						<span>Serial:</span><br />
						<input type="text" autocomplete="off" name="serial" class="form-control" v-model="objetoActivo.serial" placeholder="S/N " />
					</label>
				</fieldset>
				<br />
				<fieldset>
					<label for="" class="col-10">
						<span>Tipo:</span><br />
						<select name="tipo" id="" class="form-control" v-model="objetoActivo.tipo" required>
							<template v-for="tipo of arrTipo">
								<option :value="tipo">{{ tipo }}</option>
							</template>
						</select>
					</label>
					<br />
					<label for="" class="col-10">
						<span>Disco Duro:</span><br />
						<input type="text" autocomplete="off" name="discoDuro" class="form-control" v-model="objetoActivo.discoDuro" placeholder="256GB SSD" />
					</label>
					<br />
					<label for="" class="col-10">
						<span>Ram:</span><br />
						<input type="text" autocomplete="off" name="ram" class="form-control" v-model="objetoActivo.ram" placeholder="8GB" />
					</label>
					<br />
					<label for="" class="col-10">
						<span>Procesador:</span><br />
						<input type="text" autocomplete="off" name="procesador" class="form-control" v-model="objetoActivo.procesador" placeholder="i5 8va" />
					</label>
				</fieldset>
			</div>

			<div style="display: flex; flex-direction: column">
				<fieldset>
					<label for="" class="col-11">
						<span>Ubicación:</span><br />
						<select name="ubicacion" id="" class="form-control" v-model="objetoActivo.ubicacion" required>
							<template v-for="ubicacion of arrUbicacion">
								<option :value="ubicacion">{{ ubicacion }}</option>
							</template>
						</select>
					</label>
					<br />
					<label for="" class="col-11">
						<span>Estado:</span><br />
						<select name="estado" id="" class="form-control" v-model="objetoActivo.estado" required>
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
						<input type="email" autocomplete="off" name="asignado" class="form-control" v-model="objetoActivo.asignado" placeholder="Nombre Persona" required />
					</label>
				</fieldset>
				<br />
				<div class="col-11" style="flex: 1; display: flex; align-items: flex-end; justify-content: flex-end; column-gap: 10px">
					<button role="button" class="btn btn-success" data-bs-dismiss="modal" @click="InsertarActivo">Guardar</button>
				</div>
			</div>
		</form>
	</div>
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
