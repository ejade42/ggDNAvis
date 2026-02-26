document.addEventListener("DOMContentLoaded", function() {
  const path = window.location.pathname;
  if (path.includes("/reference/") || path.includes("/articles/") || path.includes("/news/")) {
    return; // Exits the script, so no TOC is built here
  }
  
  
  // 1. Broadest possible search for headings to guarantee it finds something
  const headings = document.querySelectorAll("h2, h3");
  
  if (headings.length === 0) {
    console.log("No headings found for TOC.");
    return;
  }

  // 2. Inject the simplest possible HTML container
  const tocHTML = `
    <div id="simple-toc">
      <h5 style="margin-top:0; padding-bottom: 10px; border-bottom: 1px solid #ddd;">Contents</h5>
      <nav id="simple-toc-nav"></nav>
    </div>
  `;
  document.body.insertAdjacentHTML('beforeend', tocHTML);

  // 3. Build the nested list
  const tocNav = document.getElementById("simple-toc-nav");
  let ulLevel1 = document.createElement("ul");
  ulLevel1.className = "toc-level-1";
  let currentH2Li = null;
  let currentH3Ul = null;

  headings.forEach(h => {
    if (!h.id) return; // Skip headings that pkgdown didn't give an ID to

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
});
