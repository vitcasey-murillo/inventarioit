<script setup>
import { Bar } from "vue-chartjs";
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from "chart.js";

const props = defineProps({
	activosTotales: [],
});

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

const dataUbicacion = ref({
	labels: ["January", "February", "March"],
	datasets: [{ label: "Cant. por Ubicación", backgroundColor: "#CD97F9", data: [40, 20, 12] }],
});

const options = ref({
	responsive: true,
	plugins: {
		legend: {
			display: true,
		},
	},
});

const indicadorUbicacion = ref(0);

function cargarDataUbicaciones() {
	let ub = [];
	let val = [];

	for (let activo of props.activosTotales) {
		let index = ub.indexOf(activo.ubicacion);

		if (index == -1) {
			ub.push(activo.ubicacion);
			val.push(1);
		} else {
			val[index]++;
		}
	}

	dataUbicacion.value.labels = ub;
	dataUbicacion.value.datasets[0].data = val;

	indicadorUbicacion.value = Math.random();
}

cargarDataUbicaciones();
</script>

<template>
	<div class="col-11">
		<Bar :key="indicadorUbicacion" :data="dataUbicacion" :options="options" />
	</div>
</template>
