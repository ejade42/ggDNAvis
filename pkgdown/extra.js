document.addEventListener("DOMContentLoaded", function() {
  // 1. Only run this on the homepage (index.html)
  if (!window.location.pathname.endsWith('/') && !window.location.pathname.endsWith('index.html')) {
    return;
  }

  // 2. Inject the HTML skeleton into the body
  const tocHTML = `
    <div id="custom-toc-container" class="collapsed">
      <div id="custom-toc-toggle" title="Toggle Table of Contents">◀</div>
      <div id="custom-toc-content">
        <h5 style="margin-top:0;">Contents</h5>
        <nav id="custom-toc-nav"></nav>
      </div>
    </div>
  `;
  document.body.insertAdjacentHTML('beforeend', tocHTML);

  // 3. Find all H2 and H3 headings in the main content
  const headings = document.querySelectorAll("main h2, main h3");
  const tocNav = document.getElementById("custom-toc-nav");
  
  if (headings.length === 0) return;

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
      currentH3Ul = null; // Reset sub-list
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

  // 5. Add the click toggle logic
  const toggleBtn = document.getElementById("custom-toc-toggle");
  const container = document.getElementById("custom-toc-container");
  
  toggleBtn.addEventListener("click", () => {
    container.classList.toggle("collapsed");
    // Swap arrow direction
    toggleBtn.textContent = container.classList.contains("collapsed") ? "◀" : "▶";
  });
});
