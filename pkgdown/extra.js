document.addEventListener("DOMContentLoaded", function() {
  // 1. Safer check: pkgdown wraps homepage content in a div with the class 'home'
  const isHome = document.querySelector(".home") !== null;
  if (!isHome) return;

  // 2. Inject HTML. Open by default
  const tocHTML = `
    <div id="custom-toc-container">
      <div id="custom-toc-toggle" title="Toggle Table of Contents">▶</div>
      <div id="custom-toc-content">
        <h5 style="margin-top:0;">Contents</h5>
        <nav id="custom-toc-nav"></nav>
      </div>
    </div>
  `;
  document.body.insertAdjacentHTML('beforeend', tocHTML);

  // 3. Find headings in the main content area
  const headings = document.querySelectorAll("main h2, main h3");
  const tocNav = document.getElementById("custom-toc-nav");
  
  if (headings.length === 0) {
    document.getElementById("custom-toc-container").style.display = 'none';
    return;
  }

  // 4. Build the hierarchical list
  let ulLevel1 = document.createElement("ul");
  ulLevel1.className = "toc-level-1";
  let currentH2Li = null;
  let currentH3Ul = null;

  headings.forEach(h => {
    if (!h.id) return; // Skip if heading has no ID

    let li = document.createElement("li");
    let a = document.createElement("a");
    a.href = "#" + h.id;
    a.textContent = h.textContent;
    li.appendChild(a);

    if (h.tagName === "H2") {
      ulLevel1.appendChild(li);
      currentH2Li = li;
      currentH3Ul = null;
    } else if (h.tagName === "H3" && currentH2Li) {
      if (!currentH3Ul) {
        currentH3Ul = document.createElement("ul");
        currentH3Ul.className = "toc-level-2";
        currentH2Li.appendChild(currentH3Ul);
      }
      currentH3Ul.appendChild(li);
    }
  });

  tocNav.appendChild(ulLevel1);

  // 5. Toggle Logic
  const toggleBtn = document.getElementById("custom-toc-toggle");
  const container = document.getElementById("custom-toc-container");
  
  toggleBtn.addEventListener("click", function() {
    container.classList.toggle("collapsed");
    toggleBtn.textContent = container.classList.contains("collapsed") ? "◀" : "▶";
  });

  // 6. Scrollspy Logic
  const tocLinks = document.querySelectorAll('#custom-toc-nav a');
  
  const updateScrollSpy = () => {
    let currentId = "";
    
    // Find the heading closest to the top of the viewport
    headings.forEach(h => {
      const rect = h.getBoundingClientRect();
      // Adjust the offset (150px) based on your top navbar height
      if (rect.top <= 150) {
        currentId = h.id;
      }
    });

    // Remove active class from all, add to the current one
    tocLinks.forEach(link => {
      link.classList.remove('active');
      if (currentId && link.getAttribute('href') === '#' + currentId) {
        link.classList.add('active');
      }
    });
  };

  // Run on scroll and once on initial load
  window.addEventListener('scroll', updateScrollSpy);
  updateScrollSpy();
});
