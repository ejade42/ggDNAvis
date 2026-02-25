document.addEventListener("DOMContentLoaded", function() {
  const isHome = document.querySelector(".home") !== null;
  if (!isHome) return;

  // Inject HTML - Notice the toggle is now a <button> instead of a <div>
  const tocHTML = `
    <div id="custom-toc-container">
      <button id="custom-toc-toggle" title="Toggle Table of Contents">▶</button>
      <div id="custom-toc-content">
        <h5 style="margin-top:0;">Contents</h5>
        <nav id="custom-toc-nav"></nav>
      </div>
    </div>
  `;
  document.body.insertAdjacentHTML('beforeend', tocHTML);

  // Find headings (broadened search just in case pkgdown layout varies)
  const headings = document.querySelectorAll(".home h2, .home h3, main h2, main h3");
  const tocNav = document.getElementById("custom-toc-nav");
  
  if (headings.length === 0) {
    document.getElementById("custom-toc-container").style.display = 'none';
    return;
  }

  // Build the list
  let ulLevel1 = document.createElement("ul");
  ulLevel1.className = "toc-level-1";
  let currentH2Li = null;
  let currentH3Ul = null;

  headings.forEach(h => {
    if (!h.id) return; 

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

  // Toggle Logic - Should now work flawlessly
  const toggleBtn = document.getElementById("custom-toc-toggle");
  const container = document.getElementById("custom-toc-container");
  
  toggleBtn.addEventListener("click", function() {
    container.classList.toggle("collapsed");
    toggleBtn.textContent = container.classList.contains("collapsed") ? "◀" : "▶";
  });

  // Scrollspy Logic
  const tocLinks = document.querySelectorAll('#custom-toc-nav a');
  
  const updateScrollSpy = () => {
    let currentId = "";
    
    headings.forEach(h => {
      const rect = h.getBoundingClientRect();
      if (rect.top <= 150) {
        currentId = h.id;
      }
    });

    tocLinks.forEach(link => {
      link.classList.remove('active');
      if (currentId && link.getAttribute('href') === '#' + currentId) {
        link.classList.add('active');
      }
    });
  };

  window.addEventListener('scroll', updateScrollSpy);
  updateScrollSpy();
});
