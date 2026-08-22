// SPDX-License-Identifier: BSD-2-Clause
(() => {
  "use strict";

  const githubUrl = "https://github.com/puffball1567/bgfxim";
  const pageIsNested = window.location.pathname.includes("/bgfx/");
  const homeUrl = pageIsNested ? "../index.html" : "index.html";
  const constantsUrl = pageIsNested ? "defines.html" : "bgfx/defines.html";

  function element(tag, className, text) {
    const node = document.createElement(tag);
    if (className) node.className = className;
    if (text) node.textContent = text;
    return node;
  }

  function installBrand(sidebar) {
    const header = element("div", "sidebar-header");
    const brand = element("a", "docs-brand");
    brand.href = homeUrl;
    brand.setAttribute("aria-label", "bgfxim API reference home");

    const mark = element("span", "brand-mark", "b");
    const words = element("span", "brand-words");
    words.append(element("strong", "", "bgfxim"));
    words.append(element("small", "", "Nim bindings for bgfx"));
    brand.append(mark, words);
    header.append(brand);

    const search = sidebar.querySelector("#searchInputDiv");
    if (search) {
      search.classList.add("docs-search");
      const input = search.querySelector("input");
      search.childNodes.forEach((node) => {
        if (node.nodeType === Node.TEXT_NODE) node.textContent = "";
      });
      if (input) {
        input.placeholder = "Search the API";
        input.setAttribute("aria-label", "Search the API");
        input.setAttribute("autocomplete", "off");
      }
      const shortcut = element("kbd", "search-shortcut", "/");
      search.append(shortcut);
      header.append(search);
    }

    const groupSelect = sidebar.querySelector('select[onchange*="groupBy"]');
    if (groupSelect && groupSelect.parentElement) {
      groupSelect.parentElement.classList.add("docs-grouping");
      header.append(groupSelect.parentElement);
    }

    sidebar.prepend(header);
    return header;
  }

  function installTopbar(content, moduleName) {
    const topbar = element("header", "docs-topbar");
    const path = element("div", "docs-path");
    path.append(element("span", "path-project", "bgfxim"));
    path.append(element("span", "path-divider", "/"));
    path.append(element("span", "path-module", moduleName));

    const actions = element("nav", "topbar-actions");
    actions.setAttribute("aria-label", "Documentation links");
    const version = element("span", "version-badge", "API 155");
    const source = element("a", "topbar-link", "GitHub");
    source.href = githubUrl;
    source.target = "_blank";
    source.rel = "noreferrer";
    const moduleLink = element(
      "a",
      "topbar-link",
      moduleName === "bgfx" ? "Constants" : "API"
    );
    moduleLink.href = moduleName === "bgfx" ? constantsUrl : homeUrl;

    const themeButton = element("button", "theme-button");
    themeButton.type = "button";
    themeButton.setAttribute("aria-label", "Toggle color theme");

    function updateThemeButton() {
      const theme = document.documentElement.getAttribute("data-theme") || "auto";
      const dark = theme === "dark" || (
        theme === "auto" && window.matchMedia("(prefers-color-scheme: dark)").matches
      );
      themeButton.textContent = dark ? "Light" : "Dark";
    }

    themeButton.addEventListener("click", () => {
      const current = document.documentElement.getAttribute("data-theme") || "auto";
      const dark = current === "dark" || (
        current === "auto" && window.matchMedia("(prefers-color-scheme: dark)").matches
      );
      if (typeof window.setTheme === "function") {
        window.setTheme(dark ? "light" : "dark");
      } else {
        document.documentElement.setAttribute("data-theme", dark ? "light" : "dark");
      }
      updateThemeButton();
    });
    updateThemeButton();

    actions.append(version, moduleLink, source, themeButton);
    topbar.append(path, actions);
    content.prepend(topbar);
  }

  function installHero(content, moduleName) {
    const hero = element("section", "docs-hero");
    const copy = element("div", "hero-copy");
    copy.append(element("span", "hero-kicker", "Complete low-level binding"));
    copy.append(element("h1", "hero-title", moduleName === "bgfx" ? "bgfx for Nim" : "Constants & helpers"));
    copy.append(element(
      "p",
      "hero-description",
      moduleName === "bgfx"
        ? "The complete, typed Nim surface for bgfx C99 API version 155."
        : "Flags, masks, capabilities, and state helpers exposed by bgfxim."
    ));

    const metrics = element("div", "hero-metrics");
    const values = moduleName === "bgfx"
      ? [["208", "public calls"], ["40", "ABI types"], ["155", "bgfx API"]]
      : [["350", "constants"], ["17", "state helpers"], ["155", "bgfx API"]];
    values.forEach(([value, label]) => {
      const metric = element("div", "hero-metric");
      metric.append(element("strong", "", value));
      metric.append(element("span", "", label));
      metrics.append(metric);
    });

    hero.append(copy, metrics);
    const topbar = content.querySelector(".docs-topbar");
    topbar.insertAdjacentElement("afterend", hero);
  }

  function improveNavigation(sidebar) {
    const toc = sidebar.querySelector("#toc-list");
    if (toc) {
      toc.setAttribute("aria-label", "API navigation");
      toc.querySelectorAll(":scope > li").forEach((item) => {
        const sectionLink = item.querySelector(".reference-toplevel");
        const sectionName = sectionLink?.textContent.trim();
        if (sectionName === "Imports" || sectionName === "Exports") item.remove();
        if (sectionLink && sectionName === "Procs") sectionLink.textContent = "Functions";
        if (sectionLink && sectionName === "Consts") sectionLink.textContent = "Constants";
        if (sectionLink && sectionName === "Templates") sectionLink.textContent = "Compatibility aliases";
      });
      toc.querySelectorAll("ul.nested-toc-section").forEach((group) => {
        const labelNode = Array.from(group.childNodes).find(
          (node) => node.nodeType === Node.TEXT_NODE && node.textContent.trim()
        );
        const link = group.querySelector(":scope > li > a");
        if (labelNode && link) {
          link.textContent = labelNode.textContent.trim();
          labelNode.remove();
        }
      });
      toc.querySelectorAll("details").forEach((details) => {
        const name = details.querySelector("summary")?.textContent.trim();
        details.open = name === "Procs" || name === "Functions";
      });
    }

    sidebar.querySelectorAll('a[href^="#"]').forEach((link) => {
      link.addEventListener("click", () => {
        sidebar.querySelectorAll("a.is-active").forEach((active) => active.classList.remove("is-active"));
        link.classList.add("is-active");
        const toggle = document.getElementById("nav-toggle");
        if (toggle && window.innerWidth < 960) toggle.checked = false;
      });
    });

    function selectHash() {
      if (!window.location.hash) return;
      const escaped = CSS.escape(window.location.hash.slice(1));
      const link = sidebar.querySelector(`a[href="#${escaped}"]`);
      if (link) {
        sidebar.querySelectorAll("a.is-active").forEach((active) => active.classList.remove("is-active"));
        link.classList.add("is-active");
      }
    }
    window.addEventListener("hashchange", selectHash);
    selectHash();
  }

  function improveSearch(sidebar) {
    const input = sidebar.querySelector("#searchInput");
    if (!input) return;
    document.addEventListener("keydown", (event) => {
      const target = event.target;
      const typing = target instanceof HTMLInputElement || target instanceof HTMLTextAreaElement;
      if (event.key === "/" && !typing) {
        event.preventDefault();
        input.focus();
        input.select();
      }
      if (event.key === "Escape" && document.activeElement === input) {
        input.value = "";
        input.dispatchEvent(new Event("input", { bubbles: true }));
        input.blur();
      }
    });
  }

  function labelSections(content) {
    content.querySelectorAll(".section > h1").forEach((heading) => {
      const section = heading.closest(".section");
      const originalName = heading.textContent.trim().toLowerCase();
      if (section) section.dataset.section = originalName;
      const labels = {
        procs: "API functions",
        consts: "Constants",
        templates: "Compatibility aliases",
      };
      const label = labels[originalName];
      const link = heading.querySelector("a");
      if (label && link) link.textContent = label;
    });
  }

  function arrangeSections(content) {
    const sections = Array.from(content.querySelectorAll(":scope > .section"));
    const byName = new Map(sections.map((section) => [section.dataset.section, section]));
    ["imports", "exports"].forEach((name) => byName.get(name)?.classList.add("utility-section"));

    let cursor = content.querySelector(".docs-hero");
    ["procs", "types", "consts", "templates"].forEach((name) => {
      const section = byName.get(name);
      if (cursor && section) {
        cursor.insertAdjacentElement("afterend", section);
        cursor = section;
      }
    });
  }

  function restoreAnchor() {
    if (!window.location.hash) return;
    const identifier = decodeURIComponent(window.location.hash.slice(1));
    window.requestAnimationFrame(() => {
      const target = document.getElementById(identifier);
      if (!target) return;
      const behavior = document.documentElement.style.scrollBehavior;
      document.documentElement.style.scrollBehavior = "auto";
      window.scrollTo(0, Math.max(0, target.getBoundingClientRect().top + window.scrollY - 80));
      document.documentElement.style.scrollBehavior = behavior;
    });
  }

  function boot() {
    const sidebar = document.querySelector(".three.columns");
    const content = document.getElementById("content");
    const generatedTitle = document.querySelector("h1.title");
    if (!sidebar || !content) return;

    const moduleName = generatedTitle?.textContent.trim() || "API Reference";
    document.body.dataset.module = moduleName;
    if (generatedTitle) generatedTitle.setAttribute("aria-hidden", "true");

    installBrand(sidebar);
    installTopbar(content, moduleName);
    installHero(content, moduleName);
    improveNavigation(sidebar);
    improveSearch(sidebar);
    labelSections(content);
    arrangeSections(content);
    restoreAnchor();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
