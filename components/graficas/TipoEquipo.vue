<script setup>
import { Bar } from "vue-chartjs";
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from "chart.js";

const props = defineProps({
	activosTotales: [],
});

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

const dataUbicacion = ref({
	labels: [],
	datasets: [{ label: "Tipo Equipo", backgroundColor: "#95B6A6", data: [] }],
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
	let tp = [];
	let val = [];

	for (let activo of props.activosTotales) {
		let index = tp.indexOf(activo.tipo);

		if (index == -1) {
			tp.push(activo.tipo);
			val.push(1);
		} else {
			val[index]++;
		}
	}

	let arrElementos = [];

	tp.forEach((x, i) => {
		arrElementos.push({
			tipo: x,
			valor: val[i],
		});
	});

	arrElementos = arrElementos.sort((a, b) => b.valor - a.valor);

	dataUbicacion.value.labels = arrElementos.map((x) => x.tipo);
	dataUbicacion.value.datasets[0].data = arrElementos.map((x) => x.valor);

	indicadorUbicacion.value = Math.random();
}

cargarDataUbicaciones();
</script>

<template>
	<div class="col-11">
		<Bar :key="indicadorUbicacion" :data="dataUbicacion" :options="options" />
	</div>
</template>
