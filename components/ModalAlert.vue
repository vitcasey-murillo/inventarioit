
<script setup>

const props = defineProps({tipo: String, titulo: String, mensaje: String, accion: Function});

const show = ref(true);
const message = ref("");

function closeModal() {
    if(!!props.accion) props.accion();
};
</script>

<template>
    <div class="modal-container">
        <div class="modal" tabindex="-1" role="dialog" style="display: block;">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" :style="props.tipo == 'success' ? 'color: black' : 'color: red' ">{{ props.titulo }}</h5>
                    
                </div>
                <div class="modal-body">
                    <p>{{ props.mensaje }}</p>
                </div>
                    <div class="modal-footer" style="justify-content: flex-end;">
                        <button type="button" :class="props.tipo == 'success' ? 'btn btn-primary' : 'btn btn-warning' " @click="closeModal">Ok</button>                    
                    </div>
                </div>
            </div>
        </div>
    </div>
  </template>
  
  
  <style scoped>
  /* Estilos básicos para el modal */
  .modal-container {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.4);
  }

  .close:hover{
    color: red;
  }
  
  </style>
  