# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Pacotes----
library("pacman")
p_load(
  shiny, bslib, shinyWidgets, shinyjs, fontawesome,
  ggplot2, plotly, dplyr,
  pdftools, magick, DT, htmltools
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Tema Visual (Profissional / Branco-Cinza-Azul-Preto)----
tema_app <- bs_theme(
  version      = 5,
  bg           = "#ffffff",
  fg           = "#1a1a1a",
  primary      = "#2563eb",
  secondary    = "#6b7280",
  success      = "#16a34a",
  warning      = "#d97706",
  danger       = "#dc2626",
  base_font    = font_google("Inter"),
  heading_font = font_google("Sora"),
  code_font    = font_google("JetBrains Mono")
)

# CSS customizado----
css_custom <- "
  :root { --nav-accent: #2563eb; --underline-color: #9ca3af; }
  body.dark-mode { --nav-accent: #60a5fa; --underline-color: #9ca3af; }

  /* ===== Tipografia ===== */
  h1, h2, h3, .hero h1, .accent-text {
    font-family: 'Sora', 'Inter', sans-serif;
    font-weight: 700;
  }
  .navbar .nav-link, .navbar-brand {
    font-family: 'Space Grotesk', 'Sora', sans-serif !important;
  }
  .dropdown-item, .stat-box .lab, .periodo-tag, .tech-badge {
    font-family: 'Sora', 'Inter', sans-serif !important;
  }
  body, p, li, .content-card, input, textarea, select, .btn {
    font-family: 'Inter', sans-serif;
  }

  /* ===== Fundo global: gradiente + particulas cobrindo 100% da tela, em toda pagina ===== */
  html {
    min-height: 100%;
    background: radial-gradient(ellipse at top right, #16213e 0%, #0b0f1a 55%, #060810 100%);
  }
  body {
    min-height: 100vh;
    padding-top: 140px;
    background: radial-gradient(ellipse at top right, #16213e 0%, #0b0f1a 55%, #060810 100%);
    color: #e5e7eb;
  }
  .tab-content, .tab-pane, .container-fluid {
    background: transparent !important;
  }
  #particles-canvas {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    z-index: -1;
    opacity: 1;
    pointer-events: none;
  }

  /* ===== Navbar flutuante ===== */
  nav.navbar.navbar-fixed-top,
  nav.navbar.navbar-fixed-top[class*='bg-'] {
    top: 20px !important;
    left: 50% !important;
    right: auto !important;
    transform: translateX(-50%);
    width: 92%;
    height: 70px !important;
    max-width: 1400px;
    background: transparent !important;
    border: 1px solid rgba(255,255,255,.4) !important;
    border-radius: 50px !important;
    box-shadow: none !important;
    z-index: 1030;
    transition: background-color .25s ease, box-shadow .25s ease, border-color .25s ease;
  }
  nav.navbar.navbar-fixed-top:hover,
  nav.navbar.navbar-fixed-top.bg-light:hover,
  nav.navbar.navbar-fixed-top.bg-body:hover,
  nav.navbar.navbar-fixed-top.bg-white:hover,
  nav.navbar.navbar-fixed-top[class*='bg-']:hover {
    background-color: #1e293b !important;
    border-color: rgba(255,255,255,.15) !important;
    box-shadow: 0 10px 30px rgba(0,0,0,.35);
  }
  .navbar-collapse,
  .navbar-nav,
  .navbar .container-fluid {
    background: transparent !important;
  }
  @supports not ((backdrop-filter: blur(1px)) or (-webkit-backdrop-filter: blur(1px))) {
    nav.navbar.navbar-fixed-top { background-color: rgba(30,41,59,.75) !important; }
  }

  .navbar .container-fluid {
    display: flex;
    align-items: center;
    position: relative;
  }
  .navbar-brand {
    position: absolute !important;
    top: 50% !important;
    right: 4% !important;
    transform: translateY(-50%);
    white-space: nowrap;
    display: flex !important;
    align-items: center;
    margin: 0 !important;
  }
  .navbar-toggler {
    order: 3 !important;
    border-color: rgba(0,0,0,.15);
  }
  .navbar-collapse {
    order: 1;
    position: absolute;
    left: 8%;
  }
  @media (max-width: 991.98px) {
    .navbar-collapse { position: static; transform: none; }
    .navbar-brand { order: 1; margin-left: 0 !important; }
    .navbar-toggler { order: 2; }
  }
  .bslib-page-navbar > .navbar + div,
  .bslib-page-dashboard > .navbar + div {
    border-top: none !important;
  }

  /* ===== Cor, tamanho e espacamento das abas ===== */
  .navbar-nav {
    gap: 34px !important;
  }
  .navbar .nav-link {
    color: #ffffff !important;
    font-weight: 600;
    font-size: 1.12rem;
    letter-spacing: .02em;
    text-shadow: 0 1px 5px rgba(0,0,0,.55);
    transition: color .2s ease;
    border-bottom: none !important;
    box-shadow: none !important;
    outline: none !important;
  }

  body:not(.dark-mode) nav.navbar.navbar-fixed-top:hover .nav-link {
    color: #ffffff !important;
    text-shadow: none;
  }
  .navbar .nav-link:hover {
    color: var(--nav-accent) !important;
    text-shadow: none;
  }

  .navbar .nav-link {
    position: relative;
  }
  .navbar .nav-link::after {
    content: '';
    position: absolute;
    left: 50%; bottom: -2px;
    width: 0%; height: 2px;
    background: var(--underline-color);
    transition: width .25s ease, left .25s ease;
  }
  .navbar .nav-link:hover::after,
  .navbar .nav-link.active::after {
    width: 70%; left: 15%;
  }
  .navbar .nav-link.active {
    font-weight: 700 !important;
    border-bottom: none !important;
    box-shadow: none !important;
  }

  /* Barra de utilidades (modo escuro / idioma / busca) ---- */
  .navbar-utils {
    display: flex;
    align-items: center;
    gap: 8px;
    position: relative;
    z-index: 5;
    height: 40px;
  }
  .navbar-utils > *{
    margin-top:0 !important;
    margin-bottom:0 !important;
  }
  .navbar-utils .bootstrap-select{
    display:flex !important;
    align-items:center !important;
  }
  .navbar-utils .bootstrap-select .dropdown-toggle{
    height:38px !important;
    display:flex !important;
    align-items:center !important;
  }
  .navbar-utils, .navbar-utils * { pointer-events: auto !important; opacity: 1 !important; }

  .navbar-utils .bootstrap-select.form-control,
  .navbar-utils .bootstrap-select .dropdown-toggle.form-control {
    background: transparent !important;
    border: none !important;
    box-shadow: none !important;
  }

  .btn-icon-nav {
    background: transparent !important;
    border: 1px solid rgba(255,255,255,.4) !important;
    color: #ffffff !important;
    border-radius: 50% !important;
    width: 38px; height: 38px;
    padding: 0 !important;
    display: flex; align-items: center; justify-content: center;
    font-size: 16px;
    transition: background-color .25s ease, border-color .2s ease, color .2s ease;
  }
  .btn-icon-nav i, .btn-icon-nav span { font-size: 18px; }
  nav.navbar.navbar-fixed-top:hover .btn-icon-nav {
    background: #1e293b !important;
  }
  body:not(.dark-mode) nav.navbar.navbar-fixed-top:hover .btn-icon-nav {
    color: #ffffff !important;
    border-color: rgba(255,255,255,.2) !important;
  }
  .btn-icon-nav:hover {
    border-color: var(--nav-accent) !important;
  }
  .btn-icon-nav:hover,
  .btn-icon-nav:hover i,
  .btn-icon-nav:hover svg,
  .btn-icon-nav:hover span,
  .btn-icon-nav:hover #icon_moon,
  .btn-icon-nav:hover #icon_sun {
    color: var(--nav-accent) !important;
  }
  .btn-icon-nav:hover svg path {
    fill: var(--nav-accent) !important;
  }

  .navbar-utils .dropdown-toggle.btn-light {
    background: transparent !important;
    border: 1px solid rgba(255,255,255,.4) !important;
    color: #ffffff !important;
    border-radius: 20px !important;
    width: 140px !important;
    height: 38px !important;
    padding-top: 0 !important;
    padding-bottom: 0 !important;
    transition: background-color .25s ease, border-color .2s ease, color .2s ease;
  }
  nav.navbar.navbar-fixed-top:hover .navbar-utils .dropdown-toggle.btn-light {
    background: #1e293b !important;
  }
  body:not(.dark-mode) nav.navbar.navbar-fixed-top:hover .navbar-utils .dropdown-toggle.btn-light {
    color: #ffffff !important;
    border-color: rgba(255,255,255,.2) !important;
  }
  .navbar-utils .dropdown-toggle.btn-light:hover {
    border-color: var(--nav-accent) !important;
    color: var(--nav-accent) !important;
  }
  .navbar-utils .dropdown-toggle.btn-light::after {
    border-top-color: currentColor !important;
  }
  .navbar-utils .dropdown-toggle.btn-light:hover::after {
    border-top-color: var(--nav-accent) !important;
  }
  .navbar-utils .dropdown-toggle.btn-light:focus,
  .navbar-utils .dropdown-toggle.btn-light:active,
  .navbar-utils .dropdown-toggle.btn-light.show {
    outline: none !important;
    box-shadow: none !important;
    border-color: rgba(255,255,255,.4) !important;
  }
  .navbar-utils .filter-option-inner-inner { color: inherit !important; }
  .navbar-utils .dropdown-toggle.btn-light:hover .filter-option-inner-inner,
  .navbar-utils .dropdown-toggle.btn-light:hover .filter-option-inner-inner * {
    color: var(--nav-accent) !important;
  }

  .bootstrap-select .filter-option{
    display:flex !important;
    align-items:center !important;
  }
  .bootstrap-select .filter-option-inner{
    display:flex !important;
    align-items:center !important;
  }
  .bootstrap-select .filter-option-inner-inner{
    display:flex !important;
    align-items:center !important;
    line-height:1 !important;
  }
  .bootstrap-select .filter-option-inner-inner img{
    display:block !important;
    width:24px;
    height:18px;
    margin-right:6px;
  }

  .navbar-utils .dropdown-menu {
    margin-top: 28px !important;
  }
  .dropdown-menu {
    border-radius: 10px;
    box-shadow: 0 6px 20px rgba(0,0,0,.10);
  }
  .navbar-utils .dropdown-menu {
    background-color: rgba(30,41,59,.55) !important;
    border: 1px solid rgba(255,255,255,.4) !important;
    transition: background-color .25s ease, border-color .25s ease;
  }
  .navbar-utils .bs-searchbox,
  .navbar-utils .bs-actionsbox,
  .navbar-utils .bs-donebutton,
  .navbar-utils .no-results {
    display: none !important;
  }
  .navbar-utils .dropdown-menu.inner {
    background: transparent !important;
    border: none !important;
    box-shadow: none !important;
    margin: 0 !important;
    padding: 4px 0 !important;
  }
  nav.navbar.navbar-fixed-top:hover .navbar-utils .dropdown-menu,
  .navbar-utils .dropdown-menu:hover {
    background-color: #1e293b !important;
    border-color: rgba(255,255,255,.15) !important;
  }
  .dropdown-item {
    color: #e5e7eb !important;
    font-size: .92rem !important;
    font-weight: 500 !important;
  }
  .dropdown-item:hover {
    background-color: rgba(37,99,235,.15) !important;
    color: #ffffff !important;
  }
  .dropdown-divider { border-color: rgba(255,255,255,.1); }

  .content-card {
    background-color: #ffffff;
    color: #1a1a1a;
    border-radius: 16px;
    padding: 28px;
    margin-bottom: 22px;
    border: 1px solid rgba(0,0,0,.06);
    box-shadow: 0 4px 18px rgba(0,0,0,.06);
    transition: background-color .25s ease, border-color .25s ease;
    scroll-margin-top: 130px;
  }

  .tech-badge {
    display: inline-block;
    background: rgba(37,99,235,.08);
    color: #2563eb;
    border: 1px solid #2563eb;
    padding: 4px 12px;
    border-radius: 20px;
    margin: 3px;
    font-size: .8rem;
  }

  .periodo-tag {
    display: inline-block;
    background: rgba(107,114,128,.12);
    color: #374151;
    padding: 3px 12px;
    border-radius: 6px;
    font-size: .85rem;
    margin-bottom: 10px;
  }

  /* ===== Hero (capa) ===== */
  .hero { text-align: center; padding: 90px 20px 60px 20px; position: relative; z-index: 1; }
  .hero img {
    width: 190px; height: 190px; object-fit: cover;
    border-radius: 50%;
    border: 4px solid #60a5fa;
    box-shadow: 0 0 40px rgba(96,165,250,.45);
    margin-top: -30px;
  }
  .hero h1 { font-size: 2.6rem; margin-top: 22px; color: #ffffff; }
  .hero .accent-text {
    background: linear-gradient(90deg, #60a5fa, #38bdf8);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }
  .hero p.subtitle { color: #dbeafe; font-size: 1.2rem; font-weight: 600; font-family: 'Sora', sans-serif; }
  .hero p:not(.subtitle) { color: #94a3b8; }
  .hero-actions { margin-top: 36px; }

  .btn-cta {
    background: linear-gradient(90deg, #9ca3af, #4b5563);
    border: none; color: #ffffff; font-weight: 600;
    padding: 10px 26px; border-radius: 30px; margin: 6px;
    font-family: 'Sora', sans-serif;
    position: relative; z-index: 1;
    display: inline-block;
    text-decoration: none !important;
  }
  .btn-cta:hover { opacity: .88; color: #ffffff; }

  /* Botao secundario (Leia mais / Ver certificado): contorno, sem preenchimento ---- */
  .btn-outline-cta {
    background: transparent;
    border: 1.5px solid #6b7280;
    color: #374151;
    font-weight: 600;
    padding: 8px 22px;
    border-radius: 30px;
    margin: 4px 6px 4px 0;
    font-family: 'Sora', sans-serif;
    display: inline-block;
    text-decoration: none !important;
    transition: background-color .2s ease, color .2s ease;
  }
  .btn-outline-cta:hover { background-color: #374151; color: #ffffff; }

  footer.app-footer {
    text-align: center; padding: 30px; color: #94a3b8;
    border-top: 1px solid rgba(255,255,255,.1); margin-top: 40px;
  }

  .cert-logo-box {
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    gap: 14px; height: 100%; text-align: center;
  }
  .cert-logo-box img { max-width: 160px; max-height: 90px; object-fit: contain; }

  .search-result-item {
    padding: 10px 14px; border-radius: 8px; cursor: pointer;
    border: 1px solid rgba(255,255,255,.1); margin-bottom: 6px;
    color: #e5e7eb;
  }
  .search-result-item:hover { background-color: rgba(37,99,235,.15); }
  .search-result-item .cat-tag { font-size: .75rem; color: #94a3b8; }

  /* Paginas de categoria: titulo/paragrafo legiveis sobre o fundo escuro global ---- */
  .hub-page p { color: #cbd5e1; }
  .hub-page hr { border-color: rgba(255,255,255,.15); }
  .hub-page .accent-text {
    background: linear-gradient(90deg, #60a5fa, #38bdf8);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  /* ===== MODO ESCURO ===== */
  html.dark-mode-html,
  body.dark-mode {
    background: radial-gradient(ellipse at top right, #10131c 0%, #06070b 55%, #030405 100%);
    color: #e5e7eb;
  }

  body.dark-mode nav.navbar.navbar-fixed-top,
  body.dark-mode nav.navbar.navbar-fixed-top[class*='bg-'] {
    background-color: rgba(20,22,28,.35) !important;
    border-color: rgba(255,255,255,.12) !important;
  }
  body.dark-mode nav.navbar.navbar-fixed-top:hover,
  body.dark-mode nav.navbar.navbar-fixed-top[class*='bg-']:hover { background-color: #14161c !important; }

  body.dark-mode .navbar .nav-link {
    color: #e5e7eb !important;
    text-shadow: 0 1px 4px rgba(0,0,0,.7);
  }
  body.dark-mode .navbar .nav-link:hover {
    color: var(--nav-accent) !important;
  }

  body.dark-mode .navbar-utils .dropdown-menu {
    background-color: rgba(20,22,28,.65) !important;
    border-color: rgba(255,255,255,.15) !important;
  }
  body.dark-mode nav.navbar.navbar-fixed-top:hover .navbar-utils .dropdown-menu,
  body.dark-mode .navbar-utils .dropdown-menu:hover {
    background-color: #14161c !important;
    border-color: rgba(255,255,255,.12) !important;
  }

  body.dark-mode .btn-icon-nav,
  body.dark-mode .navbar-utils .dropdown-toggle.btn-light {
    color: #e5e7eb !important; border-color: rgba(255,255,255,.15) !important;
  }
  body.dark-mode nav.navbar.navbar-fixed-top:hover .btn-icon-nav,
  body.dark-mode nav.navbar.navbar-fixed-top:hover .navbar-utils .dropdown-toggle.btn-light {
    background: #14161c !important;
    color: #e5e7eb !important;
    border-color: rgba(255,255,255,.15) !important;
  }
  body.dark-mode .navbar-utils .filter-option-inner-inner {
    color: #e5e7eb !important;
  }

  body.dark-mode .content-card { background-color: #171922; color: #e5e7eb; border-color: rgba(255,255,255,.06); }
  body.dark-mode footer.app-footer { color: #9ca3af; border-color: rgba(255,255,255,.06); }
"

# JavaScript da animacao de particulas (capa interativa)----
js_particles <- "
(function(){
  function initParticles(){
    var canvas = document.getElementById('particles-canvas');
    if(!canvas || canvas.dataset.ready) return;
    canvas.dataset.ready = '1';
    var ctx = canvas.getContext('2d');
    var w, h, particles = [];
    var mouse = { x: null, y: null, radius: 130 };

    function resize(){
      w = canvas.width = window.innerWidth;
      h = canvas.height = window.innerHeight;
    }
    resize();
    window.addEventListener('resize', resize);

    var count = Math.min(90, Math.floor((window.innerWidth * window.innerHeight) / 16000));
    for (var i = 0; i < count; i++) {
      particles.push({
        x: Math.random() * w,
        y: Math.random() * h,
        vx: (Math.random() - 0.5) * 0.4,
        vy: (Math.random() - 0.5) * 0.4,
        r: Math.random() * 1.8 + 1
      });
    }

    document.addEventListener('mousemove', function(e){
      mouse.x = e.clientX; mouse.y = e.clientY;
    });
    document.addEventListener('mouseleave', function(){
      mouse.x = null; mouse.y = null;
    });

    function draw(){
      ctx.clearRect(0, 0, w, h);
      for (var i = 0; i < particles.length; i++) {
        var p = particles[i];
        p.x += p.vx; p.y += p.vy;
        if (p.x < 0 || p.x > w) p.vx *= -1;
        if (p.y < 0 || p.y > h) p.vy *= -1;

        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fillStyle = 'rgba(96,165,250,0.85)';
        ctx.fill();

        for (var j = i + 1; j < particles.length; j++) {
          var q = particles[j];
          var dx = p.x - q.x, dy = p.y - q.y;
          var dist = Math.sqrt(dx * dx + dy * dy);
          if (dist < 130) {
            ctx.beginPath();
            ctx.moveTo(p.x, p.y);
            ctx.lineTo(q.x, q.y);
            ctx.strokeStyle = 'rgba(96,165,250,' + (1 - dist / 130) * 0.35 + ')';
            ctx.lineWidth = 1;
            ctx.stroke();
          }
        }

        if (mouse.x !== null) {
          var mdx = p.x - mouse.x, mdy = p.y - mouse.y;
          var mdist = Math.sqrt(mdx * mdx + mdy * mdy);
          if (mdist < mouse.radius) {
            ctx.beginPath();
            ctx.moveTo(p.x, p.y);
            ctx.lineTo(mouse.x, mouse.y);
            ctx.strokeStyle = 'rgba(255,255,255,' + (1 - mdist / mouse.radius) * 0.6 + ')';
            ctx.lineWidth = 1;
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(p.x, p.y, p.r * 1.8, 0, Math.PI * 2);
            ctx.fillStyle = 'rgba(255,255,255,0.9)';
            ctx.fill();
          }
        }
      }
      requestAnimationFrame(draw);
    }
    draw();
  }
  $(document).on('shiny:connected', initParticles);
})();
"

# JavaScript: rolar ate um item especifico apos trocar de aba (usado pela busca)----
js_scroll_to <- "
Shiny.addCustomMessageHandler('scrollToItem', function(id) {
  setTimeout(function() {
    var el = document.getElementById(id);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
      el.style.transition = 'box-shadow .3s ease';
      el.style.boxShadow = '0 0 0 3px rgba(37,99,235,.6)';
      setTimeout(function(){ el.style.boxShadow = ''; }, 1500);
    }
  }, 400);
});
"

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Traduções (infraestrutura pronta - conteudo livre ainda so em PT)----
labels <- list(
  pt = list(nav_inicio = "Início", nav_perfil = "Perfil", nav_experiencia = "Experiência",
            nav_projetos = "Projetos", nav_certificados = "Certificados",
            nav_contato = "Contato",
            btn_ver_projetos = "Ver Projetos", btn_ver_cv = "Ver Currículo", btn_fale_comigo = "Fale comigo",
            busca_placeholder = "Digite para buscar..."),
  en = list(nav_inicio = "Home", nav_perfil = "Profile", nav_experiencia = "Experience",
            nav_projetos = "Projects", nav_certificados = "Certificates",
            nav_contato = "Contact",
            btn_ver_projetos = "View Projects", btn_ver_cv = "View Resume", btn_fale_comigo = "Contact me",
            busca_placeholder = "Type to search..."),
  es = list(nav_inicio = "Inicio", nav_perfil = "Perfil", nav_experiencia = "Experiencia",
            nav_projetos = "Proyectos", nav_certificados = "Certificados",
            nav_contato = "Contacto",
            btn_ver_projetos = "Ver Proyectos", btn_ver_cv = "Ver Currículum", btn_fale_comigo = "Contáctame",
            busca_placeholder = "Escribe para buscar...")
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Base de Conteúdo (PREENCHER AOS POUCOS)----

## Perfil----
perfil <- list(
  nome        = "Michel Lima",
  cargo       = "Estatístico e Cientista de Dados em Formação",
  tagline     = "EM DESENVOLVIMENTO", # "Transformando dados em decisões" - restaurar no futuro
  bio         = "Bacharelando em Estatística e Ciência de Dados pela Universidade
  Federal de Ouro Preto (UFOP), com <em>background</em> em Ciências Econômicas e 
  experiência aplicada em consultoria estatística, iniciação científica e diagnóstico
  territorial. Atuo como Consultor Técnico em Estatística em projeto de doutoramento 
  internacional, analisando bases de dados multidimensionais para subsidiar decisões de
  pesquisa. Desenvolvo projeções populacionais para pequenas áreas e diagnósticos 
  sociodemográficos a partir de dados públicos (DATASUS, IBGE, CAGED), traduzindo 
  indicadores demográficos, epidemiológicos e socioeconômicos em insights acionáveis 
  para o planejamento público. Domínio de R, com aplicações em SQL e Shiny, além de 
  conhecimentos em Python e Power BI.",
  foto        = "img/perfil.jpg",
  email       = "michelescreva@gmail.com",
  linkedin    = "https://www.linkedin.com/in/micheldeoliveira/",
  github      = "https://github.com/michelolv",
  lattes      = "http://lattes.cnpq.br/0000000000000000",
  localizacao = "Ouro Preto, MG - Brasil",
  cv_path     = "cv/curriculo.pdf"   # caminho relativo a /www (abre em nova aba, sem download forcado)
)

## Experiências de trabalho----
experiencias <- list(
  list(
    id          = "exp1",
    empresa     = "Nome da Empresa 1",
    cargo       = "Estagiário(a) de Dados",
    periodo     = "Mar/2024 - Atual",
    local       = "Remoto",
    descricao   = c(
      "Desenvolvimento de dashboards em R Shiny / Power BI para acompanhamento de KPIs.",
      "Automatização de relatórios em R, reduzindo o tempo de entrega.",
      "Aplicação de testes estatísticos e modelos exploratórios."
    ),
    tecnologias   = c("R", "SQL", "Power BI", "Excel"),
    saiba_mais_url = "https://www.linkedin.com/in/micheldeoliveira/"
  ),
  list(
    id          = "exp2",
    empresa     = "Empresa Fictícia LTDA",
    cargo       = "Analista de Dados Júnior",
    periodo     = "Jan/2023 - Fev/2024",
    local       = "Presencial",
    descricao   = c(
      "Construção de pipelines de tratamento e limpeza de dados em R.",
      "Elaboração de relatórios gerenciais periódicos para diretoria.",
      "Apoio na modelagem estatística de indicadores de desempenho."
    ),
    tecnologias   = c("R", "Excel", "SQL"),
    saiba_mais_url = "https://www.linkedin.com/in/micheldeoliveira/"
  ),
  list(
    id          = "exp3",
    empresa     = "Instituto de Pesquisa XYZ",
    cargo       = "Bolsista de Iniciação Científica",
    periodo     = "Ago/2022 - Dez/2022",
    local       = "Híbrido",
    descricao   = c(
      "Análise exploratória de dados demográficos e socioeconômicos.",
      "Suporte na produção de relatórios técnicos para publicação.",
      "Participação em reuniões de acompanhamento de projeto de pesquisa."
    ),
    tecnologias   = c("R", "Python", "Excel"),
    saiba_mais_url = "https://www.linkedin.com/in/micheldeoliveira/"
  )
)

## Projetos diversos----
projetos <- list(
  list(
    id          = "proj1",
    titulo      = "Nome do Projeto 1",
    subtitulo   = "Curta descrição / objetivo do projeto",
    descricao   = c(
      "Contexto do problema e motivação.",
      "Metodologia estatística/ML utilizada.",
      "Principais resultados e conclusões."
    ),
    tecnologias    = c("R", "ggplot2", "Shiny"),
    link_github    = "https://github.com/seu-usuario/projeto1",
    link_demo      = NA,
    saiba_mais_url = "https://github.com/seu-usuario/projeto1"
  ),
  list(
    id          = "proj2",
    titulo      = "Dashboard de Indicadores Municipais",
    subtitulo   = "Painel interativo para acompanhamento de dados públicos",
    descricao   = c(
      "Integração de bases públicas (IBGE, DATASUS) em um único painel.",
      "Visualizações dinâmicas para comparação entre municípios.",
      "Publicação e hospedagem gratuita via Posit Connect Cloud."
    ),
    tecnologias    = c("R", "Shiny", "Plotly"),
    link_github    = "https://github.com/seu-usuario/projeto2",
    link_demo      = NA,
    saiba_mais_url = "https://github.com/seu-usuario/projeto2"
  ),
  list(
    id          = "proj3",
    titulo      = "Modelo Preditivo Fictício",
    subtitulo   = "Estudo de caso de classificação estatística",
    descricao   = c(
      "Preparação e balanceamento de base de dados de exemplo.",
      "Comparação entre diferentes modelos estatísticos/ML.",
      "Avaliação de desempenho com métricas de classificação."
    ),
    tecnologias    = c("R", "tidymodels"),
    link_github    = "https://github.com/seu-usuario/projeto3",
    link_demo      = NA,
    saiba_mais_url = "https://github.com/seu-usuario/projeto3"
  )
)

## Certificados (logo via Clearbit API a partir do dominio da instituicao - sem hospedar imagem)----
certificados <- list(
  list(
    id            = "cert1",
    titulo        = "Nome do Certificado 1",
    instituicao   = "Instituição / Plataforma",
    dominio       = "coursera.org",
    site          = "https://www.coursera.org",
    carga_horaria = "40h",
    ano           = "2024",
    descricao     = "Breve descrição do que foi aprendido no curso/certificação.",
    skills        = c("R", "Estatística"),
    pdf           = "certificados/cert1.pdf"
  ),
  list(
    id            = "cert2",
    titulo        = "Estatística Aplicada com R",
    instituicao   = "Plataforma de Ensino Fictícia",
    dominio       = "alura.com.br",
    site          = "https://www.alura.com.br",
    carga_horaria = "60h",
    ano           = "2023",
    descricao     = "Curso com foco em testes estatísticos, modelagem e visualização de dados em R.",
    skills        = c("R", "Testes Estatísticos", "Visualização"),
    pdf           = "certificados/cert2.pdf"
  ),
  list(
    id            = "cert3",
    titulo        = "Fundamentos de Ciência de Dados",
    instituicao   = "Instituição Fictícia de Tecnologia",
    dominio       = "udemy.com",
    site          = "https://www.udemy.com",
    carga_horaria = "80h",
    ano           = "2023",
    descricao     = "Formação introdutória cobrindo Python, SQL e fundamentos de Machine Learning.",
    skills        = c("Python", "SQL", "Machine Learning"),
    pdf           = "certificados/cert3.pdf"
  )
)

## Índice combinado para a busca (id -> categoria/aba de destino)----
indice_busca <- c(
  lapply(experiencias, function(x) list(id = x$id, titulo = x$empresa, categoria = "Experiência", tab = "experiencia")),
  lapply(projetos,     function(x) list(id = x$id, titulo = x$titulo,  categoria = "Projeto",     tab = "projetos")),
  lapply(certificados, function(x) list(id = x$id, titulo = x$titulo,  categoria = "Certificado", tab = "certificados"))
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Funções Auxiliares----

## Badges de tecnologia----
badge_tech <- function(techs) {
  tagList(lapply(techs, function(t) span(class = "tech-badge", t)))
}

## Bloco de Experiência (conteudo completo + botao Leia mais)----
bloco_experiencia <- function(exp) {
  div(
    id = exp$id,
    class = "content-card",
    h3(exp$cargo, class = "accent-text"),
    h5(paste0(exp$empresa, " • ", exp$local)),
    div(class = "periodo-tag", exp$periodo),
    tags$hr(),
    tags$ul(lapply(exp$descricao, tags$li)),
    h5("Tecnologias utilizadas:"),
    badge_tech(exp$tecnologias),
    tags$br(), tags$br(),
    tags$a(class = "btn-outline-cta", href = exp$saiba_mais_url, target = "_blank", "Leia mais \u2192")
  )
}

## Bloco de Projeto (conteudo completo + botao Leia mais)----
bloco_projeto <- function(proj) {
  div(
    id = proj$id,
    class = "content-card",
    h3(proj$titulo, class = "accent-text"),
    h5(proj$subtitulo),
    tags$hr(),
    tags$ul(lapply(proj$descricao, tags$li)),
    h5("Tecnologias:"),
    badge_tech(proj$tecnologias),
    tags$br(), tags$br(),
    tags$a(class = "btn btn-cta", href = proj$link_github, target = "_blank",
           icon("github"), " Repositório"),
    if (!is.na(proj$link_demo))
      tags$a(class = "btn btn-cta", href = proj$link_demo, target = "_blank",
             icon("up-right-from-square"), " Demo"),
    tags$a(class = "btn-outline-cta", href = proj$saiba_mais_url, target = "_blank", "Leia mais \u2192")
  )
}

## Bloco de Certificado (logo da instituicao + Leia mais + skills, sem pre-visualizacao de PDF)----
bloco_certificado <- function(cert) {
  logo_url <- paste0("https://logo.clearbit.com/", cert$dominio)
  div(
    id = cert$id,
    class = "content-card",
    fluidRow(
      column(
        width = 7,
        h3(cert$titulo, class = "accent-text"),
        h5(cert$instituicao),
        div(class = "periodo-tag", paste(cert$ano, "•", cert$carga_horaria)),
        tags$hr(),
        p(cert$descricao),
        h5("Skills:"),
        badge_tech(cert$skills),
        tags$br(),
        tags$a(class = "btn btn-cta", href = cert$pdf, target = "_blank",
               icon("file-lines"), " Ver certificado")
      ),
      column(
        width = 5,
        div(
          class = "cert-logo-box",
          tags$img(src = logo_url, alt = cert$instituicao,
                   onerror = "this.style.display='none';"),
          tags$a(class = "btn-outline-cta", href = cert$site, target = "_blank", "Leia mais \u2192")
        )
      )
    )
  )
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Páginas de Categoria (tudo visivel, sem cliques extras)----

pagina_experiencia_completa <- function() {
  div(
    class = "hub-page",
    style = "padding: 10px 30px 30px 30px;",
    h2("Experiência Profissional", class = "accent-text"),
    p("Um resumo de toda a minha trajetória profissional."),
    tags$hr(),
    lapply(experiencias, bloco_experiencia)
  )
}

pagina_projetos_completa <- function() {
  div(
    class = "hub-page",
    style = "padding: 10px 30px 30px 30px;",
    h2("Meus Projetos", class = "accent-text"),
    p("Uma seleção dos projetos que desenvolvi."),
    tags$hr(),
    lapply(projetos, bloco_projeto)
  )
}

pagina_certificados_completa <- function() {
  div(
    class = "hub-page",
    style = "padding: 10px 30px 30px 30px;",
    h2("Certificados", class = "accent-text"),
    p("Cursos e certificações concluídos."),
    tags$hr(),
    lapply(certificados, bloco_certificado)
  )
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Páginas Fixas (Início, Perfil, Contato)----

pagina_inicio <- function() {
  tagList(
    div(
      class = "hero",
      tags$img(src = perfil$foto),
      h1(HTML(paste0("Olá, eu sou <span class='accent-text'>", perfil$nome, "</span>"))),
      p(class = "subtitle", perfil$cargo),
      p(perfil$tagline),
      div(
        class = "hero-actions",
        actionButton("btn_ver_projetos", labels$pt$btn_ver_projetos, class = "btn-cta", icon = icon("diagram-project")),
        tags$a(class = "btn btn-cta", href = perfil$cv_path, target = "_blank",
               icon("file-lines"), " ", labels$pt$btn_ver_cv),
        actionButton("btn_ir_contato", labels$pt$btn_fale_comigo, class = "btn-cta", icon = icon("paper-plane"))
      )
    )
  )
}

pagina_perfil <- function() {
  fluidRow(
    style = "padding: 10px 30px 30px 30px;",
    column(
      width = 4,
      div(
        class = "content-card", style = "text-align:center;",
        tags$img(src = perfil$foto, style = "width:160px;height:160px;border-radius:50%;object-fit:cover;border:3px solid #2563eb;"),
        h4(perfil$nome), h6(perfil$cargo),
        p(icon("location-dot"), perfil$localizacao),
        tags$a(icon("linkedin"), href = perfil$linkedin, target = "_blank", style = "margin:6px;"),
        tags$a(icon("github"), href = perfil$github, target = "_blank", style = "margin:6px;"),
        tags$a(icon("envelope"), href = paste0("mailto:", perfil$email), style = "margin:6px;")
      )
    ),
    column(
      width = 8,
      div(class = "content-card", h3("Sobre mim", class = "accent-text"), p(HTML(perfil$bio))),
      div(class = "content-card", h3("Formação Acadêmica", class = "accent-text"),
          p("Bacharelado: Estatística e Ciência de Dados, Universidade Federal de Ouro Preto (UFOP), 8º período."))
    )
  )
}

pagina_contato <- function() {
  fluidRow(
    style = "padding: 10px 30px 30px 30px;",
    column(
      width = 6,
      div(
        class = "content-card",
        h3("Vamos conversar", class = "accent-text"),
        p(icon("envelope"), " ", perfil$email),
        p(icon("linkedin"), " ", tags$a(href = perfil$linkedin, target = "_blank", "LinkedIn")),
        p(icon("github"), " ", tags$a(href = perfil$github, target = "_blank", "GitHub")),
        p(icon("book"), " ", tags$a(href = perfil$lattes, target = "_blank", "Currículo Lattes"))
      )
    ),
    column(
      width = 6,
      div(
        class = "content-card",
        h3("Envie uma mensagem", class = "accent-text"),
        textInput("contato_nome", "Nome"),
        textInput("contato_email", "E-mail"),
        textAreaInput("contato_msg", "Mensagem", rows = 4),
        actionButton("btn_enviar_contato", "Enviar", class = "btn-cta")
      )
    )
  )
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Barra de utilidades (canto direito da navbar)----

seletor_idioma <- pickerInput(
  inputId  = "idioma",
  label    = NULL,
  choices  = c("pt", "en", "es"),
  selected = "pt",
  width    = "140px",
  options  = list(width = "140px"),
  choicesOpt = list(
    content = c(
      "<img src='https://flagcdn.com/24x18/br.png' style='width:24px;height:18px;vertical-align:middle;'> PT",
      "<img src='https://flagcdn.com/24x18/us.png' style='width:24px;height:18px;vertical-align:middle;'> EN",
      "<img src='https://flagcdn.com/24x18/es.png' style='width:24px;height:18px;vertical-align:middle;'> ES"
    )
  )
)

barra_utilidades <- tagList(
  actionButton("abrir_busca", label = tags$span(icon("magnifying-glass")),
               class = "btn-icon-nav", title = "Buscar no portfólio"),
  seletor_idioma,
  actionButton(
    "toggle_dark",
    label = tagList(
      tags$span(id = "icon_moon", icon("moon")),
      tags$span(id = "icon_sun", icon("sun"), style = "display:none;")
    ),
    class = "btn-icon-nav", title = "Alternar modo claro/escuro"
  )
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# UI----
ui <- navbarPage(
  title       = div(class = "navbar-utils", barra_utilidades),
  id          = "navbar_principal",
  theme       = tema_app,
  collapsible = TRUE,
  position    = "fixed-top",
  header      = tagList(
    useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet",
                href = "https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700;800&family=Space+Grotesk:wght@500;600;700&display=swap"),
      tags$style(HTML(css_custom)),
      tags$script(HTML(js_particles)),
      tags$script(HTML(js_scroll_to))
    ),
    tags$canvas(id = "particles-canvas")
  ),
  
  tabPanel(tags$span(id = "lbl_inicio", "Início"), value = "inicio", pagina_inicio()),
  tabPanel(tags$span(id = "lbl_perfil", "Perfil"), value = "perfil", pagina_perfil()),
  tabPanel(tags$span(id = "lbl_experiencia", "Experiência"), value = "experiencia", pagina_experiencia_completa()),
  tabPanel(tags$span(id = "lbl_projetos", "Projetos"), value = "projetos", pagina_projetos_completa()),
  tabPanel(tags$span(id = "lbl_certificados", "Certificados"), value = "certificados", pagina_certificados_completa()),
  tabPanel(tags$span(id = "lbl_contato", "Contato"), value = "contato", pagina_contato()),
  
  footer = tags$footer(
    class = "app-footer",
    p(paste0("© ", format(Sys.Date(), "%Y"), " ", perfil$nome, " — Portfólio em Estatística & Ciência de Dados"))
  )
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Server----
server <- function(input, output, session) {
  
  ## Deep-linking: sincroniza aba ativa com a URL (?aba=id)----
  observe({
    query <- parseQueryString(session$clientData$url_search)
    if (!is.null(query$aba)) {
      updateNavbarPage(session, "navbar_principal", selected = query$aba)
    }
  })
  
  observeEvent(input$navbar_principal, {
    updateQueryString(paste0("?aba=", input$navbar_principal), mode = "push")
  }, ignoreInit = TRUE)
  
  ## Modo Claro/Escuro----
  modo_escuro <- reactiveVal(FALSE)
  observeEvent(input$toggle_dark, {
    novo_estado <- !modo_escuro()
    modo_escuro(novo_estado)
    shinyjs::toggleClass(selector = "body", class = "dark-mode")
    shinyjs::toggle(id = "icon_moon", condition = !novo_estado)
    shinyjs::toggle(id = "icon_sun",  condition = novo_estado)
  })
  
  ## Idioma: atualiza rotulos do menu e botoes da capa----
  observeEvent(input$idioma, {
    lg <- labels[[input$idioma]]
    for (nm in c("inicio", "perfil", "experiencia", "projetos", "certificados", "contato")) {
      shinyjs::runjs(sprintf(
        "var el = document.getElementById('lbl_%s'); if (el) el.textContent = '%s';",
        nm, lg[[paste0("nav_", nm)]]
      ))
    }
    updateActionButton(session, "btn_ver_projetos", label = lg$btn_ver_projetos)
    updateActionButton(session, "btn_ir_contato",  label = lg$btn_fale_comigo)
  }, ignoreInit = TRUE)
  
  ## Busca: leva a categoria certa e rola ate o item----
  observeEvent(input$abrir_busca, {
    showModal(modalDialog(
      title = "Buscar no portfólio",
      textInput("busca_txt", NULL, placeholder = labels$pt$busca_placeholder, width = "100%"),
      uiOutput("resultados_busca"),
      easyClose = TRUE, footer = NULL
    ))
  })
  
  output$resultados_busca <- renderUI({
    req(nchar(input$busca_txt %||% "") > 0)
    termo <- tolower(input$busca_txt)
    encontrados <- Filter(function(x) grepl(termo, tolower(x$titulo)), indice_busca)
    if (length(encontrados) == 0) return(p("Nenhum resultado encontrado."))
    tagList(lapply(encontrados, function(x) {
      div(
        class = "search-result-item",
        onclick = sprintf("Shiny.setInputValue('busca_click', {id:'%s', tab:'%s'}, {priority:'event'})", x$id, x$tab),
        span(class = "cat-tag", x$categoria), br(), strong(x$titulo)
      )
    }))
  })
  
  observeEvent(input$busca_click, {
    updateNavbarPage(session, "navbar_principal", selected = input$busca_click$tab)
    session$sendCustomMessage("scrollToItem", input$busca_click$id)
    removeModal()
  })
  
  ## Navegação via botões da capa----
  observeEvent(input$btn_ver_projetos, {
    updateNavbarPage(session, "navbar_principal", selected = "projetos")
  })
  observeEvent(input$btn_ir_contato, {
    updateNavbarPage(session, "navbar_principal", selected = "contato")
  })
  
  ## Formulário de contato----
  observeEvent(input$btn_enviar_contato, {
    showNotification("Mensagem registrada! (integrar envio real de e-mail futuramente)", type = "message")
  })
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Executar Aplicação----
shinyApp(ui, server)