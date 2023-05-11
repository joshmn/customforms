import { Controller } from "@hotwired/stimulus"
import { Sortable } from "sortablejs"
import { patch } from '@rails/request.js'

export default class extends Controller {
    initialize() {
        this.onUpdate = this.onUpdate.bind(this)
    }
    connect() {
// Initialize SortableJS on the main list
        var sortableList = document.getElementById('sortable-list');
        var sortable = Sortable.create(sortableList, {
            animation: 150,
            ghostClass: 'ghost',
            onEnd: function (event) {
                // console.log('Position changed');
            },
            onUpdate: this.onUpdate
        });

// Initialize SortableJS on each nested list
        var nestedLists = document.querySelectorAll('#sortable-list ul');
        for (var i = 0; i < nestedLists.length; i++) {
            var nestedSortable = Sortable.create(nestedLists[i], {
                animation: 150,
                ghostClass: 'ghost',
                onEnd: function (event) {
                    //    console.log('Position changed');
                },
                onUpdate: this.onUpdate

            });
        }

    }

    async onUpdate ({ item, newIndex }) {
        if (!item.dataset.sortableUpdateUrl) return

        const param = "field[position]";

        const data = new FormData()
        data.append(param, newIndex + 1)

        patch(item.dataset.sortableUpdateUrl, { body: data, responseKind: "turbo-stream" })

    }
}
