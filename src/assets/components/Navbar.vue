<template>
  <nav
    :class="[
      'fixed top-0 left-0 right-0 z-50 transition-all duration-300',
      isScrolled ? 'bg-white shadow-sm py-2' : 'bg-transparent py-4'
    ]"
  >
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center">
        <div class="text-2xl font-bold text-gray-900"></div>
        
        <!-- Desktop Navigation -->
        <div class="hidden md:flex items-center gap-1">
          <template v-for="item in navItems" :key="item.id">
            <!-- Item with dropdown -->
            <div
              v-if="item.children"
              class="relative"
              @mouseenter="openMenu = item.id"
              @mouseleave="openMenu = null"
            >
              <button
                :class="[
                  'px-3 py-2 rounded font-medium flex items-center gap-1',
                  isActive(item) ? 'text-gray-900' : 'text-gray-600'
                ]"
                @click="scrollTo(item.id)"
              >
                {{ item.label }}
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                    viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                    class="transition-transform"
                    :class="{ 'rotate-180': openMenu === item.id }">
                  <polyline points="6 9 12 15 18 9"></polyline>
                </svg>
              </button>

              <div v-show="openMenu === item.id" class="nav-dropdown">
                <button
                  v-for="child in item.children"
                  :key="child.id"
                  class="nav-dropdown-item"
                  :class="activeSection === child.id ? 'text-gray-900' : 'text-gray-600'"
                  @click="scrollTo(child.id)"
                >
                  {{ child.label }}
                </button>
              </div>
            </div>

            <!-- Plain item -->
            <button
              v-else
              :class="[
                'px-3 py-2 rounded font-medium',
                activeSection === item.id ? 'text-gray-900' : 'text-gray-600'
              ]"
              @click="scrollTo(item.id)"
            >
              {{ item.label }}
            </button>
          </template>
        </div>

        <!-- Mobile Menu Button -->
        <div class="md:hidden">
          <button 
            class="p-2 rounded text-gray-600"
            @click="mobileMenuOpen = !mobileMenuOpen"
          >
            <span v-if="mobileMenuOpen">✕</span>
            <span v-else>☰</span>
          </button>
        </div>
      </div>
    </div>

    <!-- Mobile Menu -->
    <div v-if="mobileMenuOpen" class="md:hidden bg-white p-4 nav-mobile-menu">
      <div class="flex flex-col space-y-1">
        <template v-for="item in navItems" :key="item.id">
          <button
            :class="[
              'px-3 py-2 rounded text-left font-medium',
              activeSection === item.id ? 'text-gray-900' : 'text-gray-600'
            ]"
            @click="scrollTo(item.id)"
          >
            {{ item.label }}
          </button>
          <button
            v-for="child in item.children || []"
            :key="child.id"
            class="nav-mobile-child"
            :class="activeSection === child.id ? 'text-gray-900' : 'text-gray-600'"
            @click="scrollTo(child.id)"
          >
            {{ child.label }}
          </button>
        </template>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'NavbarComponent', // שינינו ל-multi-word
  props: {
    activeSection: {
      type: String,
      required: true
    },
    isScrolled: {
      type: Boolean,
      required: true
    }
  },
  data() {
    return {
      mobileMenuOpen: false,
      openMenu: null,
      navItems: [
        { id: "home", label: "Home" },
        {
          id: "about",
          label: "About",
          children: [
            { id: "education", label: "Education" },
            { id: "experience", label: "Work Experience" },
            { id: "skills", label: "Technical Skills" },
            { id: "military", label: "Military Service" },
            { id: "volunteering", label: "Volunteering" }
          ]
        },
        { id: "projects", label: "Projects" },
        { id: "contact", label: "Contact" }
      ]
    }
  },
  methods: {
    isActive(item) {
      if (this.activeSection === item.id) return true;
      return (item.children || []).some(child => child.id === this.activeSection);
    },
    scrollTo(id) {
      const element = document.getElementById(id);
      if (!element) return;

      // Offset for the fixed navbar so headings aren't hidden behind it.
      const top = element.getBoundingClientRect().top + window.scrollY - 80;
      window.scrollTo({ top, behavior: "smooth" });

      this.mobileMenuOpen = false;
      this.openMenu = null;
    }
  }
}
</script>

<style scoped>
button {
  background: none;
  border: none;
  cursor: pointer;
  transition: color 0.3s;
}

button:hover {
  color: #000;
}

/* Tailwind isn't compiled in this project, so dropdown layout is defined here. */
.nav-dropdown {
  position: absolute;
  left: 0;
  top: 100%;
  min-width: 14rem;
  background: #fff;
  border: 1px solid #f3f4f6;
  border-radius: 0.5rem;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
  padding: 0.5rem 0;
  z-index: 60;
}

.nav-dropdown-item {
  display: block;
  width: 100%;
  text-align: left;
  padding: 0.5rem 1rem;
  font-weight: 500;
  white-space: nowrap;
}

.nav-dropdown-item:hover {
  background-color: #f9fafb;
}

.nav-mobile-menu {
  max-height: 80vh;
  overflow-y: auto;
}

.nav-mobile-child {
  text-align: left;
  padding: 0.5rem 0.75rem 0.5rem 1.75rem;
  font-size: 0.875rem;
}
</style>