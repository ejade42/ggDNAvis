document.addEventListener("DOMContentLoaded", function () {
  const isHome = document.querySelector(".home") !== null;
  if (!isHome) return;

  // 1. Inject HTML structure (Open by default: no 'collapsed' class)
  const html = `
    <div id="toc-wrapper">
      <button id="toc-toggle" title="Toggle Table of Contents">▶</button>
      <div id="toc-resize-handle"></div>
      <div id="toc-panel">
        <h5 style="margin-top:0;">Contents</h5>
        <nav id="toc-nav"></nav>
      </div>
    </div>
  `;
  document.body.insertAdjacentHTML('beforeend', html);

  // 2. Generate Hierarchical TOC
  const headings = document.querySelectorAll(".home h2, .home h3, main h2, main h3");
  const tocNav = document.getElementById("toc-nav");

  if (headings.length === 0) {
    document.getElementById("toc-wrapper").style.display = 'none';
    return;
  }

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

  // 3. Toggle Logic
  const toggle = document.getElementById("toc-toggle");
  const wrapper = document.getElementById("toc-wrapper");

  toggle.addEventListener("click", function () {
    wrapper.classList.toggle("collapsed");
    toggle.textContent = wrapper.classList.contains("collapsed") ? "◀" : "▶";
  });

  // 4. Resize Logic (Adapted from your script)
  const handle = document.getElementById('toc-resize-handle');
  const panel = document.getElementById('toc-panel');

  function resizePanel(e) {
    const newWidth = window.innerWidth - e.clientX;
    // Set boundaries so it doesn't get too small or swallow the whole screen
    if (newWidth > 150 && newWidth < 600) {
      panel.style.width = `${newWidth}px`;
    }
  }

  function stopResize() {
    document.removeEventListener('mousemove', resizePanel);
    document.removeEventListener('mouseup', stopResize);
    document.body.style.userSelect = ""; // Re-enable text selection after drag
  }

  handle.addEventListener('mousedown', function (e) {
    document.addEventListener('mousemove', resizePanel);
    document.addEventListener('mouseup', stopResize);
    document.body.style.userSelect = "none"; // Prevent highlighting text while dragging
  });

  // 5. Scrollspy Logic
  const tocLinks = document.querySelectorAll('#toc-nav a');
  
  const updateScrollSpy = () => {
    let currentId = "";
    headings.forEach(h => {
      if (h.getBoundingClientRect().top <= 150) {
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
