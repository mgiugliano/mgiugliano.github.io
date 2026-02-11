// Search functionality using Lunr.js
(function() {
  let searchIndex = null;
  let searchData = [];

  // Determine the site root from the search.js script location
  // The script is at <root>/static/js/search.js
  function getSiteRoot() {
    var scripts = document.getElementsByTagName('script');
    for (var i = 0; i < scripts.length; i++) {
      var src = scripts[i].src;
      var match = src.match(/^(.*?)\/static\/js\/search\.js/);
      if (match) {
        return match[1];
      }
    }
    // Fallback: use the current page's directory
    return window.location.href.substring(0, window.location.href.lastIndexOf('/'));
  }

  var siteRoot = getSiteRoot();

  // Load search index
  async function loadSearchIndex() {
    try {
      // Add cache-busting parameter using current timestamp
      const cacheBust = Date.now();
      const response = await fetch(`${siteRoot}/search-index.json?v=${cacheBust}`);
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

  // Escape HTML to prevent XSS
  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
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
      const excerpt = result.content.substring(0, 150) + (result.content.length > 150 ? '...' : '');
      const safeTitle = escapeHtml(result.title);
      const safeExcerpt = escapeHtml(excerpt);
      
      const item = document.createElement('div');
      item.className = 'search-result-item';
      item.addEventListener('click', function() {
        if (result.url) {
          window.location.href = siteRoot + '/' + result.url;
        }
      });
      
      const titleDiv = document.createElement('div');
      titleDiv.className = 'search-result-title';
      titleDiv.textContent = result.title;
      
      const excerptDiv = document.createElement('div');
      excerptDiv.className = 'search-result-excerpt';
      excerptDiv.textContent = excerpt;
      
      item.appendChild(titleDiv);
      item.appendChild(excerptDiv);
      
      return item;
    });

    resultsContainer.innerHTML = '';
    html.forEach(item => resultsContainer.appendChild(item));
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
