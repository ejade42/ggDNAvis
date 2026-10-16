document.addEventListener("DOMContentLoaded", function() {
  const path = window.location.pathname;
  if (path.includes("/reference/") || path.includes("/articles/") || path.includes("/news/") || path.includes("LICENSE") || path.includes("authors.html")) {
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
  
  
  
  // Hide basic TOC from md
  const firstList = document.querySelector("main ul");
  if (firstList) {
    const firstLink = firstList.querySelector("a");
    if (firstLink && firstLink.getAttribute("href").startsWith("#")) {
      firstList.style.display = "none";
    }
  }
  
  
  
  // Scroll tracker
  function onScroll() {
    let currentActiveId = "";
    
    // Find which heading is currently closest to the top of the screen
    headings.forEach(h => {
      const rect = h.getBoundingClientRect();
      if (rect.top < window.innerHeight / 2) { 
        currentActiveId = h.id;
      }
    });

    if (currentActiveId) {
      // First, remove the active state from everything
      tocNav.querySelectorAll("a").forEach(a => a.classList.remove("active-link"));
      tocNav.querySelectorAll("li").forEach(li => li.classList.remove("active-li"));

      // Find the link for the section we are currently viewing
      const activeLink = tocNav.querySelector(`a[href="#${currentActiveId}"]`);
      if (activeLink) {
        activeLink.classList.add("active-link"); // Highlight the text
        
        // Walk upwards to expand all parent folders
        let parent = activeLink.parentElement;
        while (parent && parent.id !== "simple-toc") {
          if (parent.tagName === "LI") {
            parent.classList.add("active-li"); // Expands the list
          }
          parent = parent.parentElement;
        }
      }
    }
  }

  // Listen for scrolling, and run it once on load to set the initial state
  window.addEventListener("scroll", onScroll);
  onScroll();
  
  
  
  // Code for toggling toc
  const tocContainer = document.getElementById("simple-toc");

  if (tocContainer) {
    const arrowBtn = document.createElement("button");
    arrowBtn.id = "toc-arrow-btn";
    
    // Since your TOC is on the right, pointing right means "push to the edge to hide"
    arrowBtn.innerHTML = "▶"; 

    // Insert the button at the top
    tocContainer.prepend(arrowBtn);

    arrowBtn.addEventListener("click", function() {
      tocContainer.classList.toggle("toc-hidden");
      
      if (tocContainer.classList.contains("toc-hidden")) {
        arrowBtn.innerHTML = "◀"; // Point left to show it can expand back out
      } else {
        arrowBtn.innerHTML = "▶"; // Point right to close
      }
    });
  }
});
