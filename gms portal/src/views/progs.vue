<template>
    <div>
<!--        <Navigation /> -->
    		<div class="home">
    		  <ItemsList :list="list"/>
    		</div>
	</div>
</template>

<script>
import ItemsList from '@/components/ItemsList.vue'
import Navigation from '@/components/navigation.vue'

export default {
  name: 'home',
  computed: {
      list() { return this.$store.state.programs }
  },
  components: { ItemsList, Navigation } 
}
</script>
