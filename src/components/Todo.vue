<template>
  <div
    class="todo"
    :class="{ complete: completed, incomplete: !completed, important: important, selected: selected }"
    @click="select"
  >
    <div class="todo-left">
      <check-box
        class="check-box no-drag"
        :dimWhenChecked="true"
        :checked="completed"
        @toggled="toggleCompleted"
      />
      <span class="summary">{{ summary }}</span>
    </div>

    <div class="todo-right">
      <div class="important-button no-drag" title="Toggle Important" @click.stop="toggleImportant">
        <alert-circle-outline-icon title="Toggle Important" />
      </div>

      <div v-show="snoozeDatetime != null && snoozeDatetime > Date.now()" class="snoozed-label">
        <sleep-icon />
        <span class="snoozed-label-text">Snoozed until {{ formattedSnoozeDatetime }}</span>
      </div>

      <div v-show="hasNotes" class="notes-icon" title="This tahsk has notes">
        <text-icon title="This tahsk has notes" />
      </div>
    </div>
  </div>
</template>

<script>
import api from "../api";
import CheckBox from "./CheckBox.vue";
import EventBus from "../eventBus.js";
import helpers from "../helpers";

// Icons
import AlertCircleOutlineIcon from "icons/AlertCircleOutline.vue";
import SleepIcon from "icons/Sleep.vue";
import TextIcon from "icons/Text.vue";

export default {
  components: {
    AlertCircleOutlineIcon,
    CheckBox,
    SleepIcon,
    TextIcon,
  },

  props: {
    listIndex: { type: Number, required: true },
    todoIndex: { type: Number, required: true },
    id: { type: Number, required: true },
    summary: { type: String, required: true },
    completedDatetime: { type: Date },
    important: { type: Boolean, required: true },
    snoozeDatetime: { type: Date },
    selectedTodoId: { type: Number },
    notes: { type: String },
  },

  computed: {
    completed: function () {
      if (this.completedDatetime == null) {
        return false;
      } else {
        return true;
      }
    },

    selected: function () {
      if (this.id == this.selectedTodoId) {
        return true;
      } else {
        return false;
      }
    },

    formattedSnoozeDatetime: function () {
      return helpers.formatDate(this.snoozeDatetime);
    },

    hasNotes: function () {
      if (this.notes != null && this.notes != "") {
        return true;
      } else {
        return false;
      }
    },
  },

  methods: {
    toggleCompleted: function () {
      var newCompletedDatetime = null;
      if (this.completed == false) {
        newCompletedDatetime = new Date();
      }
      EventBus.$emit("update-todo-by-index", this.listIndex, this.todoIndex, {
        completedDatetime: newCompletedDatetime,
      });
    },

    toggleImportant: function () {
      EventBus.$emit("update-todo-by-index", this.listIndex, this.todoIndex, {
        important: !this.important,
      });
    },

    select: function () {
      EventBus.$emit("select-todo", this.id);
    },
  },
};
</script>

<style lang="scss" scoped>
@import "../common";

.todo {
  height: auto;
  min-height: $todoMinHeight;
  margin: 0 0 4px 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: grab;
  background-color: $bgLightColor;
  border-left: 4px solid transparent;
  color: $offWhite;
  font-size: 14px;
  div {
    display: flex;
    align-items: center;
  }
  @media (hover: hover) {
    &:hover {
      background-color: lighten($bgLightColor, 2%);
    }
  }

  &.sortable-drag {
    display: none;
  }

  &.sortable-chosen {
    transition: transform 200ms ease 100ms;
    background-color: lighten($bgLightColor, 10%);
    transform: scaleX(1.02);
  }
}

.todo-left {
  flex: 1 1 auto;
}

.todo-right {
  flex: 1 1 auto;
  flex-direction: row-reverse;
  min-width: $todoMinHeight;
  @media (hover: hover) {
    &:hover {
      .important-button {
        width: $todoMinHeight;
      }
    }
  }
}

.important-button {
  background-color: $brandOrange;
  color: $offWhite;
  width: 0;
  height: $todoMinHeight;
  transition: width 200ms;
  cursor: pointer;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  .material-design-icon__svg {
    bottom: 0;
  }
}

.check-box {
  margin: 0 10px;
}

.summary {
  margin: 6px 0 6px 0;
}

.selected {
  &.todo {
    background-color: lighten($bgLightColor, 10%);
    border-left-color: lighten($bgLightColor, 10%);
  }
}

.complete {
  .summary {
    text-decoration: line-through;
    color: $subduedColor;
  }
}

.important {
  &.todo {
    border-left-color: $brandOrange;
  }
}

.snoozed-label {
  font-size: 14px;
  color: $subduedColor;
  .snoozed-label-text {
    margin: 0 14px 0 4px;
  }
}

.notes-icon {
  margin: 0 8px 4px 0;
  font-size: 20px;
  color: $subduedColor;
}
</style>