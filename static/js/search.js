// Search functionality using Lunr.js
(function() {
  let searchIndex = null;
  let searchData = [];

  // Load search index
  async function loadSearchIndex() {
    try {
      const response = await fetch('/search-index.json');
      const data = await response.json();
      searchData = data;

      // Build Lunr index
      searchIndex = lunr(function() {
        this.ref('url');
        this.field('title', { boost: 10 });
        this.field('content');
        this.field('tags', { boost: 5 });

        data.forEach(doc => {
          this.add(doc);
        });
      });
    } catch (error) {
      console.error('Error loading search index:', error);
    }
  }

  // Perform search
  function performSearch(query) {
    if (!searchIndex || !query.trim()) {
      return [];
    }

    try {
      const results = searchIndex.search(query);
      return results.map(result => {
        const doc = searchData.find(d => d.url === result.ref);
        return doc;
      }).filter(Boolean);
    } catch (error) {
      console.error('Search error:', error);
      return [];
    }
  }

  // Display search results
  function displayResults(results) {
    const resultsContainer = document.getElementById('search-results');
    
    if (results.length === 0) {
      resultsContainer.innerHTML = '<div class="search-no-results">No results found</div>';
      resultsContainer.classList.add('active');
      return;
    }

    const html = results.map(result => {
      const excerpt = result.content.substring(0, 150) + '...';
      return `
        <div class="search-result-item" onclick="window.location.href='${result.url}'">
          <div class="search-result-title">${result.title}</div>
          <div class="search-result-excerpt">${excerpt}</div>
        </div>
      `;
    }).join('');

    resultsContainer.innerHTML = html;
    resultsContainer.classList.add('active');
  }

  // Hide search results
  function hideResults() {
    const resultsContainer = document.getElementById('search-results');
    resultsContainer.classList.remove('active');
  }

  // Initialize search
  function initSearch() {
    const searchInput = document.getElementById('search-input');
    const resultsContainer = document.getElementById('search-results');

    if (!searchInput) return;

    // Load search index on page load
    loadSearchIndex();

    // Handle search input
    let searchTimeout;
    searchInput.addEventListener('input', function(e) {
      const query = e.target.value;

      clearTimeout(searchTimeout);

      if (query.length < 2) {
        hideResults();
        return;
      }

      searchTimeout = setTimeout(() => {
        const results = performSearch(query);
        displayResults(results);
      }, 300);
    });

    // Hide results when clicking outside
    document.addEventListener('click', function(e) {
      if (!searchInput.contains(e.target) && !resultsContainer.contains(e.target)) {
        hideResults();
      }
    });

    // Handle escape key
    searchInput.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        hideResults();
        searchInput.blur();
      }
    });
  }

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initSearch);
  } else {
    initSearch();
  }
})();
