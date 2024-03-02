<script setup></script>

<template>
	<Head>
		<title>Inventarasdasdio IT</title>

		<Link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" crossorigin="anonymous" />

		<Script
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
			integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
			crossorigin="anonymous"
		></Script>

		<Link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" />

		<Link href="https://cdn.datatables.net/buttons/1.6.5/css/buttons.dataTables.css" rel="stylesheet" type="text/css" />
	</Head>
	<div style="display: grid; grid-template-columns: 15% 85%">
		<!-- Sidebar / Navigation -->

		<div class="col-auto sidebar">
			<div class="d-flex flex-column align-items-center align-items-sm-start px-3 pt-2 text-white min-vh-100">
				<h4 style="width: 100%; text-align: center">
					INVENTARIO <br />
					DE IT
				</h4>
				<br style="margin: 50px 0px" />
				<ul class="nav nav-pills flex-column mb-sm-auto mb-0 align-items-center align-items-sm-start" id="menu">
					<li class="nav-item">
						<NuxtLink to="/activos" class="nav-link"> Activos </NuxtLink>
					</li>
					<li>
						<NuxtLink to="/mantenimiento" class="nav-link"> Mantenimiento </NuxtLink>
					</li>
					<li>
						<NuxtLink to="/historial" class="nav-link"> Historial Manten. </NuxtLink>
					</li>
					<li>
						<NuxtLink to="/dashboard" class="nav-link"> Dashboard </NuxtLink>
					</li>
					<li>
						<NuxtLink to="/data" class="nav-link"> Data </NuxtLink>
					</li>
					<!-- Add more navigation items here -->
				</ul>
			</div>
		</div>

		<slot />
	</div>
</template>

<style>
body {
	background-color: #f8f9fa;
}
.sidebar {
	background-color: #20315c;
	color: white;
}
.sidebar ul {
	padding-left: 0;
	list-style: none;
}

.sidebar ul li a {
	color: white;
	text-decoration: none;
}
.profile-header-container {
	text-align: center;
	background-color: #ff6f61;
	color: white;
	padding: 20px;
}
.profile-header-img {
	padding: 54px;
	position: relative;
	top: -22px;
	margin-bottom: -22px;
}
.profile-header-img img.img-circle {
	width: 100px;
	height: 100px;
	border: 2px solid white;
	border-radius: 50%;
}
.profile-header-info h1 {
	font-size: 24px;
	margin-bottom: 0;
}
.profile-header-info h2 {
	font-size: 12px;
	margin: 0;
}
.profile-header-info p {
	font-size: 14px;
	margin-top: 15px;
}
</style>
