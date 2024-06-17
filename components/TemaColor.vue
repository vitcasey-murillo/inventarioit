
<script setup>
  
  const isDarkMode = ref(false);

  const toggleDarkMode = () => {
    
    //isDarkMode.value = !isDarkMode.value;
    
    document.body.classList.toggle('dark-mode', isDarkMode.value);
    localStorage.setItem('tema', isDarkMode.value ? 'dark' : 'light');

    console.log("tema: ", localStorage.getItem("tema"))
  };

  onMounted(() => {
    isDarkMode.value = localStorage.getItem('tema') === 'dark';
    document.body.classList.toggle('dark-mode', isDarkMode.value);
  });
</script>

<template>
    <div class="form-check form-switch">
      <input 
        class="form-check-input" 
        type="checkbox" 
        id="darkModeSwitch" 
        v-model="isDarkMode" 
        @change="toggleDarkMode"
      >
      <label class="form-check-label txt-color" for="darkModeSwitch">
        {{ isDarkMode ? 'Dark Mode' : 'Light Mode' }}
      </label>
    </div>
  </template>
  
  
  <style scoped>
  </style>
  