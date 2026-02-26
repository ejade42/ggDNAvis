document.addEventListener("DOMContentLoaded", function() {
  const path = window.location.pathname;
  if (path.includes("/reference/") || path.includes("/articles/") || path.includes("/news/")) {
    return; // Exits the script, so no TOC is built here
  }
  
  
  // Search for headings
  const headings = document.querySelectorAll("main h1, main h2, main h3");
  
  if (headings.length === 0) {
    console.log("No headings found for TOC.");
    return;
  }
  
  // Delete existing containers
  const existingTocs = document.querySelectorAll("#simple-toc");
  existingTocs.forEach(toc => toc.remove());

  // Inject the simple HTML container
  const tocHTML = `
    <div id="simple-toc">
      <h5 style="margin-top:0; padding-bottom: 10px; border-bottom: 1px solid #ddd;">Contents</h5>
      <nav id="simple-toc-nav"></nav>
    </div>
  `;
  document.body.insertAdjacentHTML('beforeend', tocHTML);


  // Build nested list
  const tocNav = document.getElementById("simple-toc-nav");
  let rootUl = document.createElement("ul");
  rootUl.className = "toc-level-1";
  
  let currentH1Li = null; let currentH1Ul = null;
  let currentH2Li = null; let currentH2Ul = null;
  
  const seenText = new Set();

  headings.forEach(h => {
    if (!h.id || h.id === "links" || h.id === "license" || h.id === "citation" || h.id === "table-of-contents") return; 
    if (h.closest('#toc, .toc, #TOC, nav')) return;

    const cleanText = h.textContent.trim();
    if (seenText.has(cleanText)) return;
    seenText.add(cleanText); 

    let li = document.createElement("li");
    let a = document.createElement("a");
    a.href = "#" + h.id;
    a.textContent = cleanText;
    li.appendChild(a);

    // Cascading logic to nest H3 under H2, and H2 under H1
    if (h.tagName === "H1") {
      rootUl.appendChild(li);
      currentH1Li = li;
      currentH1Ul = null; 
      currentH2Li = null; 
      currentH2Ul = null;
    } else if (h.tagName === "H2") {
      if (currentH1Li) {
        if (!currentH1Ul) {
          currentH1Ul = document.createElement("ul");
          currentH1Ul.className = "toc-level-2";
          currentH1Li.appendChild(currentH1Ul);
        }
        currentH1Ul.appendChild(li);
      } else {
        rootUl.appendChild(li); // Fallback if no H1 exists yet
      }
      currentH2Li = li;
      currentH2Ul = null;
    } else if (h.tagName === "H3") {
      if (currentH2Li) {
        if (!currentH2Ul) {
          currentH2Ul = document.createElement("ul");
          currentH2Ul.className = "toc-level-3";
          currentH2Li.appendChild(currentH2Ul);
        }
        currentH2Ul.appendChild(li);
      } else if (currentH1Li) {
        if (!currentH1Ul) {
          currentH1Ul = document.createElement("ul");
          currentH1Ul.className = "toc-level-2";
          currentH1Li.appendChild(currentH1Ul);
        }
        currentH1Ul.appendChild(li); // Fallback if no H2 exists
      } else {
        rootUl.appendChild(li);
      }
    }
  });

  tocNav.appendChild(rootUl);
});
