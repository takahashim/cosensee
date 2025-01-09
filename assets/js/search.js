function searchComponent() {
  return {
    query: '',
    results: [],
    fuse: null,
    lastResults: [],

    async init() {
      try {
        const response = await fetch("/search.json");
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        this.fuse = new Fuse(data, {
          keys: ["title", "summary"],
          threshold: 0.3,
        });
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
