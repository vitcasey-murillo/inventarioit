
<script setup>

const props = defineProps({titulo: String, mensaje: String, accion: Function});

const show = ref(true);
const message = ref("");

function closeModal(respuesta) {
    if(!!props.accion) props.accion(respuesta);
};
</script>

<template>
    <div class="modal-container">
        <div class="modal" tabindex="-1" role="dialog" style="display: block;">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">{{ props.titulo }}</h5>
                    
                </div>
                <div class="modal-body">
                    <p>{{ props.mensaje }}</p>
                </div>
                    <div class="modal-footer" style="justify-content: space-between;">
                        <button type="button" class="btn btn-secondary" @click="closeModal(false)">NO</button>
                        <button type="button" class="btn btn-danger" @click="closeModal(true)">SI</button>                    
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
  