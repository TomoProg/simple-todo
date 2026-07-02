<script setup>
import { computed, onMounted, ref } from 'vue'

const API_BASE = 'http://localhost:3000'

const todos = ref([])
const newTitle = ref('')
const loading = ref(false)
const saving = ref(false)
const errorMessage = ref('')

const completedCount = computed(() => todos.value.filter((todo) => todo.completed).length)

async function fetchTodos() {
  loading.value = true
  errorMessage.value = ''
  try {
    const response = await fetch(`${API_BASE}/todos`)
    if (!response.ok) {
      throw new Error('TODOの取得に失敗しました')
    }
    todos.value = await response.json()
  } catch (error) {
    errorMessage.value = error.message
  } finally {
    loading.value = false
  }
}

async function addTodo() {
  const title = newTitle.value.trim()
  if (!title) return

  saving.value = true
  errorMessage.value = ''
  try {
    const response = await fetch(`${API_BASE}/todos`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ todo: { title, completed: false } }),
    })

    if (!response.ok) {
      throw new Error('TODOの追加に失敗しました')
    }

    const created = await response.json()
    todos.value = [created, ...todos.value]
    newTitle.value = ''
  } catch (error) {
    errorMessage.value = error.message
  } finally {
    saving.value = false
  }
}

async function toggleTodo(todo) {
  errorMessage.value = ''
  const response = await fetch(`${API_BASE}/todos/${todo.id}`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ todo: { completed: !todo.completed } }),
  })

  if (!response.ok) {
    errorMessage.value = 'TODOの更新に失敗しました'
    return
  }

  const updated = await response.json()
  todos.value = todos.value.map((item) => (item.id === updated.id ? updated : item))
}

async function removeTodo(todo) {
  errorMessage.value = ''
  const response = await fetch(`${API_BASE}/todos/${todo.id}`, {
    method: 'DELETE',
  })

  if (!response.ok) {
    errorMessage.value = 'TODOの削除に失敗しました'
    return
  }

  todos.value = todos.value.filter((item) => item.id !== todo.id)
}

onMounted(fetchTodos)
</script>

<template>
  <main class="app-shell">
    <section class="todo-panel">
      <header class="panel-header">
        <p class="eyebrow">Simple Todo</p>
        <h1>今日やること</h1>
        <p class="meta">{{ completedCount }} / {{ todos.length }} 完了</p>
      </header>

      <form class="composer" @submit.prevent="addTodo">
        <input
          v-model="newTitle"
          type="text"
          placeholder="やることを入力"
          :disabled="saving"
        />
        <button type="submit" :disabled="saving || !newTitle.trim()">
          {{ saving ? '追加中...' : '追加' }}
        </button>
      </form>

      <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
      <p v-if="loading" class="state">読み込み中...</p>
      <p v-else-if="todos.length === 0" class="state">TODOはまだありません</p>

      <ul v-else class="todo-list">
        <li v-for="todo in todos" :key="todo.id" :class="{ done: todo.completed }">
          <label>
            <input
              type="checkbox"
              :checked="todo.completed"
              @change="toggleTodo(todo)"
            />
            <span>{{ todo.title }}</span>
          </label>
          <button class="danger" @click="removeTodo(todo)">削除</button>
        </li>
      </ul>
    </section>
  </main>
</template>
