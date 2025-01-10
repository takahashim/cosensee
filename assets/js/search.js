import Fuse from 'https://cdn.jsdelivr.net/npm/fuse.js@6.6.2/dist/fuse.esm.js';

export function createSearch() {
  return {
    query: '',
    results: [],
    fuse: null,
    lastResults: [],

    async init() {
      try {
        const res = await fetch("/search.json");
        if (!res.ok) {
          throw new Error(`Error HTTP status: ${res.status}`);
        }
        const data = await res.json();
        this.fuse = new Fuse(data, { keys: ["title", "summary"], threshold: 0.3 });
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    },

    search() {
      if (!this.fuse || this.query.trim() === '') {
        this.clearResults();
        return;
      }
      this.results = this.fuse.search(this.query);
      this.lastResults = this.results;
    },

    clearResults() {
      this.results = [];
    },

    restoreResults() {
      if (this.query.trim() !== '' && this.lastResults.length > 0) {
        this.results = this.lastResults;
      }
    },
  };
}
