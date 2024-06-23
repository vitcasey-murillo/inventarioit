<script setup>
import { useRoute } from 'vue-router';

definePageMeta({
	middleware: "auth",
});

const route = useRoute();

const user = useSupabaseUser();
const client = useSupabaseClient();

async function cerrarSesion() {
	try {
		const { error } = await client.auth.signOut();

		if (error) {
			throw error;
		} else {
			navigateTo("/login");
		}
	} catch (ex) {
		alert("Error: " + ex.message);
	}
}

async function rutaCambiarContra() {
	let mensaje = `¿Desea solicitar cambio de contraseña para ${user.value.email}?\n\nRecibirá un correo con el enlace.`;

	if (confirm(mensaje)) {
		try {
			const { data, error } = await client.auth.resetPasswordForEmail(user.value.email, {
				redirectTo: `${location.origin}/register_newpass`,
			});

			if (error) {
				throw error;
			}
		} catch (ex) {
			alert("Error: " + ex.message);
		}
	}
}


function brindarClase(solicitante){
	const ruta = route.path;

	if(ruta.includes(solicitante))
	{
		return "nav-link txt-color active";
	}
	return "nav-link txt-color link-dark";
}


onMounted(()=> {
	
	window.addEventListener("resize", ()=>{
		console.log("resize")
		const width = window.innerWidth;

		if(width < 1200)
		{
			panelColapsado.value = true;
		}else if(width >= 1200){
			panelColapsado.value = false;
		}

	})

})

const panelColapsado = ref(false);

</script>

<template>
	<Head>
		<title>Inventario IT</title>

		<Link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" crossorigin="anonymous" />

		<Script
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
			integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
			crossorigin="anonymous"
		></Script>
		<Link rel="icon" type="image/png" href="/icon.png" />
		<Link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" />

		<Link href="https://cdn.datatables.net/buttons/1.6.5/css/buttons.dataTables.css" rel="stylesheet" type="text/css" />
	</Head>

	<div style="display: grid; grid-template-columns: 15% 85%" :class="panelColapsado ? 'contenedor-global' : '' ">

		<div class="d-flex flex-column flex-shrink-0 p-3 bg-tema panel-colapsado" style="height: 100vh;">
			<a href="/" class="link-dark text-decoration-none" style="display: flex; flex-direction: column; align-items: center; justify-content: flex-end;">
				<span class="fs-4 txt-color" style="font-weight: bold; display: block !important">{{ !panelColapsado ? 'Inventario ' : '' }}IT</span>
				<img src="/logo.png" class="banner" style="width: 25%;" />
				</a>
			<hr>
			<ul class="nav nav-pills flex-column mb-auto" style="flex: 1;">
			<li class="nav-item">
				<NuxtLink to="/activos" :class="brindarClase('/activos')" aria-current="page">
					<i class="bi bi-box-fill"></i>
				<span>Activos</span>
				</NuxtLink>
			</li>
			<li>
				<NuxtLink to="/mantenimiento" :class="brindarClase('/mantenimiento')">
					<i class="bi bi-tools"></i>
				<span>Mantenimiento</span>
				</NuxtLink>
			</li>
			<li>
				<NuxtLink to="/historial" :class="brindarClase('/historial')">
					<i class="bi bi-calendar-week-fill"></i>
				<span>Historial</span>
				</NuxtLink>
			</li>
			<li>
				<NuxtLink to="/dashboard" :class="brindarClase('/dashboard')">
					<i class="bi bi-bar-chart-fill"></i>
				<span>Metricas</span>
				</NuxtLink>
			</li>
			<li>
				<NuxtLink to="/data" :class="brindarClase('/data')">
					<i class="bi bi-bookmark-check-fill"></i>
				<span>Data</span>
				</NuxtLink>
			</li>
			</ul>
			<div style="height: 100%;" @dblclick="panelColapsado = !panelColapsado">

			</div>
			<hr>
			<div class="dropdown">
				<a href="#" class="d-flex align-items-center link-dark text-decoration-none dropdown-toggle txt-color" data-bs-toggle="dropdown" aria-expanded="false">
					<i class="bi bi-gear-fill"></i> 
					<strong class="email-usuario" style="padding-left: 5px;">{{ user.email.includes("@unitec.edu.hn") ? (user.email).replace("@unitec.edu.hn", "") : (user.email).replace("@unitec.edu","") }}</strong>
				</a>
				<ul class="dropdown-menu text-small shadow bg-tema" style="">
					<li><TemaColor /></li>
					<li><a class="dropdown-item txt-color" href="#" @click="rutaCambiarContra">Cambiar Contraseña</a></li>
					<li><hr class="dropdown-divider"></li>
					<li><a class="dropdown-item txt-color" href="#" @click="cerrarSesion">Cerrar Sesión</a></li>
				</ul>
			</div>
		</div>

		<slot />
	</div>	
</template>

<style>


body .bg-tema{
	background-color: #F8F9FA;	
}


body.dark-mode .bg-tema{
	background-color: #333 !important;
}

body .txt-color{
	color: #222 !important;
}

body.dark-mode .txt-color{
	color: #fff !important;
}


body .bg-sub-tema{
	background-color: unset;	
}


body, body.dark-mode .bg-sub-tema{
	background-color: #eeea !important;
}


.nav-link span{
	padding-left: 5px;
}

.contenedor-global{
	grid-template-columns: 5% 95% !important;
}


.contenedor-global .panel-colapsado .banner{
	display: none;
}

.contenedor-global .panel-colapsado i{
	font-size: 2.5rem;
}

.contenedor-global .panel-colapsado span{
	display: none;
}

.contenedor-global .panel-colapsado .email-usuario{
	display: none;
}

</style>
