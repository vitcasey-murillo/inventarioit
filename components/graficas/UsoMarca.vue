<script setup>
import { Pie } from "vue-chartjs";
import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement, CategoryScale, LinearScale } from "chart.js";

const props = defineProps({
	activosTotales: [],
});

ChartJS.register(Title, Tooltip, Legend, ArcElement, CategoryScale, LinearScale);

const indicadorUbicacion = ref(0);

const dataPie = ref({
	labels: ["VueJs", "EmberJs", "ReactJs", "AngularJs"],
	datasets: [
		{
			label: "Marca Usada",
			backgroundColor: ["#41B883", "#E46651", "#00D8FF", "#DD1B16", "#D42B86"],
			data: [40, 20, 80, 10],
		},
	],
});

const options = ref({
	responsive: true,
	plugins: {
		legend: {
			display: true,
		},
	},
});

function generarColor() {
	const popularColors = [
		"#FF5733", // Rojo
		"#FFC300", // Amarillo
		"#DAF7A6", // Verde pastel
		"#C70039", // Carmesí
		"#00BFFF", // Azul cielo profundo
		"#0000FF", // Azul
		"#FF00FF", // Magenta
		"#800080", // Púrpura
		"#FFC0CB", // Rosa
		"#FFD700", // Oro
		"#008000", // Verde
		"#4B0082", // Índigo
		"#F08080", // Coral claro
		"#90EE90", // Verde claro
		"#ADD8E6", // Azul claro
		"#E0FFFF", // Cian claro
		"#FF6347", // Tomate
		"#20B2AA", // Verde mar medio
		"#778899", // Gris pizarra claro
	];
	const index = Math.floor(Math.random() * popularColors.length);
	return popularColors[index];
}

function cargarDataUbicaciones() {
	let mrc = [];
	let col = [];
	let val = [];

	for (let activo of props.activosTotales) {
		let index = mrc.indexOf(activo.marca);

		if (index == -1) {
			mrc.push(activo.marca);
			col.push(generarColor());
			val.push(1);
		} else {
			val[index]++;
		}
	}

	dataPie.value.labels = mrc;
	dataPie.value.datasets[0].backgroundColor = col;
	dataPie.value.datasets[0].data = val;

	indicadorUbicacion.value = Math.random();
}

cargarDataUbicaciones();
</script>

<template>
	<div class="col-7">
		<Pie :key="indicadorUbicacion" :data="dataPie" :options="options" />
	</div>
</template>
