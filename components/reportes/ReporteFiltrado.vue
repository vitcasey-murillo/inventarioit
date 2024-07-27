<script setup>
import { DataTable } from "~/DataTableImports";

const fechaMostrar = ref("yyyy-MM-dd");

function calcularFechaActual() {
  const fechaActual = new Date();

  const año = fechaActual.getFullYear();
  const mes = fechaActual.getMonth() + 1; // getMonth() devuelve un valor de 0 a 11, así que sumamos 1
  const dia = fechaActual.getDate();

  const mesFormateado = mes < 10 ? `0${mes}` : mes;
  const diaFormateado = dia < 10 ? `0${dia}` : dia;

  const fechaFormateada = `${año}-${mesFormateado}-${diaFormateado}`;
  fechaMostrar.value = fechaFormateada;
}
calcularFechaActual();

const columnas = [
  { title: "Marca", data: "marca" },
  { title: "Modelo", data: "modelo" },
  { title: "Serial", data: "serial" },
  { title: "Tipo", data: "tipo" },
  { title: "DiscoDuro", data: "discoDuro" },
  { title: "Ram", data: "ram" },
  { title: "Ubicacion", data: "ubicacion" },
  { title: "Asignado A", data: "asignado" },
  { title: "Estado", data: "estado" },
];

const props = defineProps({
  activosMostrados: [],
});
</script>

<template>
  <DataTable
    id="tablaactivos"
    :data="activosMostrados"
    :columns="columnas"
    class="table dataTable table-striped table-bordered"
    style="width: 100%"
    :options="{
      pageLength: 8,
      responsive: true,
      autoWidth: false,

      dom: 'Brtip',
      buttons: [
        { title: `Inventario IT - ${fechaMostrar}`, extend: 'excelHtml5' },
        { title: `Inventario IT - ${fechaMostrar}`, extend: 'print' },
      ],
    }"
  >
  </DataTable>
</template>

<style></style>
