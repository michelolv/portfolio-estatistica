# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Pacotes----
library("pacman")
p_load(
  shiny, bslib, shinyWidgets, shinyjs, fontawesome,
  ggplot2, plotly, dplyr,
  pdftools, magick, DT, htmltools
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Tema Visual----
tema_app <- bs_theme(
  version      = 5,
  bg           = "#0b0f1a",
  fg           = "#e5e7eb",
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
  :root {
    --nav-accent: #2563eb;
    --underline-color: #9ca3af;
    --panel-bg: rgba(30,41,59,.72);
    --panel-border: rgba(255,255,255,.10);
  }
  body.dark-mode { --nav-accent: #60a5fa; --underline-color: #9ca3af; }

  /* ===== Tipografia: stack solicitado (Graphik indisponivel, cai para Helvetica) ===== */
  h1, h2, h3, .hero h1, .accent-text,
  .navbar .nav-link, .navbar-brand,
  .dropdown-item, .stat-box .lab, .periodo-tag, .tech-badge,
  body, p, li, .content-card, input, textarea, select, .btn {
    font-family: 'Graphik', Helvetica, Arial, sans-serif, 'Lucida Sans Unicode';
    font-weight: 500;
  }
  h1, h2, h3, .accent-text { font-weight: 700; }

  html, body { background-color: #060810; }
  body { min-height: 100vh; padding-top: 140px; color: #e5e7eb; }
  .tab-content, .tab-pane, .container-fluid { background: transparent !important; }

  /* ===== Fundo fixo em relacao a JANELA (nao ao tamanho da pagina) ===== */
  #app-bg-gradient {
    position: fixed; inset: 0; z-index: -2;
    background: radial-gradient(ellipse at top right, #16213e 0%, #0b0f1a 55%, #060810 100%);
  }
  body.dark-mode #app-bg-gradient {
    background: radial-gradient(ellipse at top right, #10131c 0%, #06070b 55%, #030405 100%);
  }
  #particles-canvas {
    position: fixed; inset: 0; z-index: -1;
    pointer-events: none;
  }

  /* ===== Navbar flutuante, com backdrop leve sempre visivel e auto-esconder ao rolar ===== */
  nav.navbar.navbar-fixed-top,
  nav.navbar.navbar-fixed-top[class*='bg-'] {
    top: 20px !important;
    left: 50% !important;
    right: auto !important;
    transform: translateX(-50%);
    width: 92%;
    height: 70px !important;
    max-width: 1400px;
    background-color: rgba(15,23,42,.45) !important;
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    border: 1px solid rgba(255,255,255,.15) !important;
    border-radius: 50px !important;
    box-shadow: 0 4px 20px rgba(0,0,0,.25);
    z-index: 1030;
    transition: background-color .25s ease, box-shadow .25s ease, border-color .25s ease, transform .3s ease;
  }
  nav.navbar.navbar-fixed-top.nav-hidden {
    transform: translateX(-50%) translateY(-140px) !important;
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
  .navbar-collapse, .navbar-nav, .navbar .container-fluid { background: transparent !important; }

  .navbar .container-fluid { display: flex; align-items: center; position: relative; }
  .navbar-brand {
    position: absolute !important; top: 50% !important; right: 4% !important;
    transform: translateY(-50%); white-space: nowrap;
    display: flex !important; align-items: center; margin: 0 !important;
  }
  .navbar-toggler { order: 3 !important; border-color: rgba(255,255,255,.2); }
  .navbar-collapse { order: 1; position: absolute; left: 8%; }
  @media (max-width: 991.98px) {
    .navbar-collapse { position: static; transform: none; }
    .navbar-brand { order: 1; margin-left: 0 !important; }
    .navbar-toggler { order: 2; }
  }
  .bslib-page-navbar > .navbar + div, .bslib-page-dashboard > .navbar + div { border-top: none !important; }

  .navbar-nav { gap: 34px !important; }
  .navbar .nav-link {
    color: #ffffff !important; font-weight: 600; font-size: 1.12rem; letter-spacing: .02em;
    text-shadow: 0 1px 5px rgba(0,0,0,.55); transition: color .2s ease;
    border-bottom: none !important; box-shadow: none !important; outline: none !important;
    position: relative;
  }
  .navbar .nav-link:hover { color: var(--nav-accent) !important; text-shadow: none; }
  .navbar .nav-link::after {
    content: ''; position: absolute; left: 50%; bottom: -2px; width: 0%; height: 2px;
    background: var(--underline-color); transition: width .25s ease, left .25s ease;
  }
  .navbar .nav-link:hover::after, .navbar .nav-link.active::after { width: 70%; left: 15%; }
  .navbar .nav-link.active { font-weight: 700 !important; }

  /* Barra de utilidades ---- */
  .navbar-utils { display: flex; align-items: center; gap: 8px; position: relative; z-index: 5; height: 40px; }
  .navbar-utils > * { margin-top:0 !important; margin-bottom:0 !important; }
  .navbar-utils .bootstrap-select { display:flex !important; align-items:center !important; }
  .navbar-utils .bootstrap-select .dropdown-toggle { height:38px !important; display:flex !important; align-items:center !important; }
  .navbar-utils, .navbar-utils * { pointer-events: auto !important; opacity: 1 !important; }
  .navbar-utils .bootstrap-select.form-control,
  .navbar-utils .bootstrap-select .dropdown-toggle.form-control { background: transparent !important; border: none !important; box-shadow: none !important; }

  .btn-icon-nav {
    background: transparent !important; border: 1px solid rgba(255,255,255,.4) !important; color: #ffffff !important;
    border-radius: 50% !important; width: 38px; height: 38px; padding: 0 !important;
    display: flex; align-items: center; justify-content: center; font-size: 16px;
    transition: background-color .25s ease, border-color .2s ease, color .2s ease;
  }
  .btn-icon-nav i, .btn-icon-nav span { font-size: 18px; }
  nav.navbar.navbar-fixed-top:hover .btn-icon-nav { background: #1e293b !important; }
  .btn-icon-nav:hover { border-color: var(--nav-accent) !important; }
  .btn-icon-nav:hover, .btn-icon-nav:hover i, .btn-icon-nav:hover svg, .btn-icon-nav:hover span,
  .btn-icon-nav:hover #icon_moon, .btn-icon-nav:hover #icon_sun { color: var(--nav-accent) !important; }
  .btn-icon-nav:hover svg path { fill: var(--nav-accent) !important; }

  .navbar-utils .dropdown-toggle.btn-light {
    background: transparent !important; border: 1px solid rgba(255,255,255,.4) !important; color: #ffffff !important;
    border-radius: 20px !important; width: 140px !important; height: 38px !important;
    padding-top: 0 !important; padding-bottom: 0 !important;
    transition: background-color .25s ease, border-color .2s ease, color .2s ease;
  }
  nav.navbar.navbar-fixed-top:hover .navbar-utils .dropdown-toggle.btn-light { background: #1e293b !important; }
  .navbar-utils .dropdown-toggle.btn-light:hover { border-color: var(--nav-accent) !important; color: var(--nav-accent) !important; }
  .navbar-utils .dropdown-toggle.btn-light::after { border-top-color: currentColor !important; }
  .navbar-utils .dropdown-toggle.btn-light:hover::after { border-top-color: var(--nav-accent) !important; }
  .navbar-utils .dropdown-toggle.btn-light:focus, .navbar-utils .dropdown-toggle.btn-light:active,
  .navbar-utils .dropdown-toggle.btn-light.show { outline: none !important; box-shadow: none !important; border-color: rgba(255,255,255,.4) !important; }
  .navbar-utils .filter-option-inner-inner { color: inherit !important; }
  .navbar-utils .dropdown-toggle.btn-light:hover .filter-option-inner-inner,
  .navbar-utils .dropdown-toggle.btn-light:hover .filter-option-inner-inner * { color: var(--nav-accent) !important; }

  .bootstrap-select .filter-option { display:flex !important; align-items:center !important; }
  .bootstrap-select .filter-option-inner { display:flex !important; align-items:center !important; }
  .bootstrap-select .filter-option-inner-inner { display:flex !important; align-items:center !important; line-height:1 !important; }
  .bootstrap-select .filter-option-inner-inner img { display:block !important; width:24px; height:18px; margin-right:6px; }

  .navbar-utils .dropdown-menu { margin-top: 28px !important; background-color: rgba(30,41,59,.85) !important; border: 1px solid rgba(255,255,255,.4) !important; border-radius: 10px; box-shadow: 0 6px 20px rgba(0,0,0,.30); }
  .navbar-utils .bs-searchbox, .navbar-utils .bs-actionsbox, .navbar-utils .bs-donebutton, .navbar-utils .no-results { display: none !important; }
  .navbar-utils .dropdown-menu.inner { background: transparent !important; border: none !important; box-shadow: none !important; margin: 0 !important; padding: 4px 0 !important; }
  .dropdown-item { color: #e5e7eb !important; font-size: .92rem !important; font-weight: 500 !important; }
  .dropdown-item:hover { background-color: rgba(37,99,235,.15) !important; color: #ffffff !important; }
  .dropdown-divider { border-color: rgba(255,255,255,.1); }

  /* ===== Painel/card padrao: vidro escuro, texto claro ===== */
  .content-card {
    background-color: var(--panel-bg);
    backdrop-filter: blur(6px); -webkit-backdrop-filter: blur(6px);
    color: #e5e7eb;
    border-radius: 16px; padding: 26px; margin-bottom: 22px;
    border: 1px solid var(--panel-border);
    box-shadow: 0 4px 22px rgba(0,0,0,.25);
    scroll-margin-top: 130px;
  }
  .content-card h3, .content-card h4, .content-card h5, .content-card h6 { color: #f1f5f9; }

  .tech-badge { display: inline-block; background: rgba(96,165,250,.12); color: #93c5fd; border: 1px solid #60a5fa; padding: 4px 12px; border-radius: 20px; margin: 3px; font-size: .8rem; }
  .periodo-tag { display: inline-block; background: rgba(148,163,184,.15); color: #cbd5e1; padding: 3px 12px; border-radius: 6px; font-size: .85rem; margin-bottom: 10px; }

  /* ===== Hero (capa) ===== */
  .hero { text-align: center; padding: 90px 20px 40px 20px; position: relative; z-index: 1; }
  .hero img { width: 190px; height: 190px; object-fit: cover; border-radius: 50%; border: 4px solid #60a5fa; box-shadow: 0 0 40px rgba(96,165,250,.45); margin-top: -30px; }
  .hero h1 { font-size: 2.6rem; margin-top: 22px; color: #ffffff; }
  .hero .accent-text { background: linear-gradient(90deg, #60a5fa, #38bdf8); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
  .hero p.subtitle { color: #dbeafe; font-size: 1.2rem; font-weight: 600; }
  .hero p:not(.subtitle) { color: #94a3b8; }
  .hero-actions { margin-top: 60px; }

  .btn-cta { background: linear-gradient(90deg, #9ca3af, #4b5563); border: none; color: #ffffff; font-weight: 600; padding: 10px 26px; border-radius: 30px; margin: 6px; position: relative; z-index: 1; display: inline-block; text-decoration: none !important; }
  .btn-cta:hover { opacity: .88; color: #ffffff; }

  /* Coluna de acoes padronizada (imagem/grafico + botoes empilhados) ---- */
  .side-media { text-align: center; }
  .side-media img { max-width: 100%; border-radius: 12px; border: 1px solid var(--panel-border); margin-bottom: 14px; }
  .side-actions { display: flex; flex-direction: column; gap: 10px; margin-top: 10px; }
  .side-actions .btn-cta, .side-actions .btn-outline-cta { width: 100%; text-align: center; margin: 0; }

  .btn-outline-cta {
    background: transparent; border: 1.5px solid #94a3b8; color: #e2e8f0; font-weight: 600;
    padding: 8px 22px; border-radius: 30px; display: inline-block; text-decoration: none !important;
    transition: background-color .2s ease, color .2s ease;
  }
  .btn-outline-cta:hover { background-color: #94a3b8; color: #0b0f1a; }

  footer.app-footer { text-align: center; padding: 30px; color: #94a3b8; border-top: 1px solid rgba(255,255,255,.1); margin-top: 40px; }

  .cert-logo-box { display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 10px; text-align: center; }
  .cert-logo-box img { max-width: 160px; max-height: 90px; object-fit: contain; }

  .search-result-item { padding: 10px 14px; border-radius: 8px; cursor: pointer; border: 1px solid rgba(255,255,255,.1); margin-bottom: 6px; color: #e5e7eb; }
  .search-result-item:hover { background-color: rgba(37,99,235,.15); }
  .search-result-item .cat-tag { font-size: .75rem; color: #94a3b8; }

  .hub-page p { color: #cbd5e1; }
  .hub-page hr { border-color: rgba(255,255,255,.15); }
  .hub-page .accent-text { background: linear-gradient(90deg, #60a5fa, #38bdf8); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }

  /* ===== Formulario de contato modernizado ===== */
  .modern-form .form-group { margin-bottom: 22px; }
  .modern-form label { display: block; font-size: .8rem; text-transform: uppercase; letter-spacing: .05em; color: #94a3b8; margin-bottom: 6px; }
  .modern-form .form-control {
    background: transparent !important; border: none !important; border-bottom: 1.5px solid rgba(255,255,255,.25) !important;
    border-radius: 0 !important; color: #f1f5f9 !important; padding: 8px 2px !important; box-shadow: none !important;
    transition: border-color .2s ease;
  }
  .modern-form .form-control:focus { border-bottom-color: #60a5fa !important; }
  .modern-form .form-control::placeholder { color: #64748b; }
  .modern-form .btn-cta { width: 100%; padding: 12px; font-size: 1rem; }

  /* Modal de busca: titulo legivel ---- */
  .modal-content { background-color: #0f172a; color: #e5e7eb; }
  .modal-title { color: #111111 !important; }
  .modal-header, .modal-footer { border-color: rgba(255,255,255,.1); }

  /* ===== MODO ESCURO ===== */
  body.dark-mode #app-bg-gradient {
    background: radial-gradient(ellipse at top right, #10131c 0%, #06070b 55%, #030405 100%);
  }
  body.dark-mode nav.navbar.navbar-fixed-top { background-color: rgba(10,12,18,.55) !important; border-color: rgba(255,255,255,.12) !important; }
  body.dark-mode nav.navbar.navbar-fixed-top:hover { background-color: #14161c !important; }
  body.dark-mode .content-card { background-color: rgba(20,22,30,.75); border-color: rgba(255,255,255,.08); }
  body.dark-mode footer.app-footer { color: #9ca3af; border-color: rgba(255,255,255,.06); }
"

# JavaScript: particulas + esconder navbar ao rolar----
js_particles <- "
(function(){
  function initParticles(){
    var canvas = document.getElementById('particles-canvas');
    if(!canvas || canvas.dataset.ready) return;
    canvas.dataset.ready = '1';
    var ctx = canvas.getContext('2d');
    var w, h, particles = [];
    var mouse = { x: null, y: null, radius: 130 };

    function resize(){ w = canvas.width = window.innerWidth; h = canvas.height = window.innerHeight; }
    resize();
    window.addEventListener('resize', resize);

    var count = Math.min(90, Math.floor((window.innerWidth * window.innerHeight) / 16000));
    for (var i = 0; i < count; i++) {
      particles.push({ x: Math.random()*w, y: Math.random()*h, vx: (Math.random()-0.5)*0.4, vy: (Math.random()-0.5)*0.4, r: Math.random()*1.8+1 });
    }
    document.addEventListener('mousemove', function(e){ mouse.x = e.clientX; mouse.y = e.clientY; });
    document.addEventListener('mouseleave', function(){ mouse.x = null; mouse.y = null; });

    function draw(){
      ctx.clearRect(0,0,w,h);
      for (var i=0;i<particles.length;i++){
        var p=particles[i]; p.x+=p.vx; p.y+=p.vy;
        if(p.x<0||p.x>w) p.vx*=-1; if(p.y<0||p.y>h) p.vy*=-1;
        ctx.beginPath(); ctx.arc(p.x,p.y,p.r,0,Math.PI*2); ctx.fillStyle='rgba(96,165,250,0.85)'; ctx.fill();
        for (var j=i+1;j<particles.length;j++){
          var q=particles[j]; var dx=p.x-q.x, dy=p.y-q.y; var dist=Math.sqrt(dx*dx+dy*dy);
          if(dist<130){ ctx.beginPath(); ctx.moveTo(p.x,p.y); ctx.lineTo(q.x,q.y); ctx.strokeStyle='rgba(96,165,250,'+(1-dist/130)*0.35+')'; ctx.lineWidth=1; ctx.stroke(); }
        }
        if(mouse.x!==null){
          var mdx=p.x-mouse.x, mdy=p.y-mouse.y; var mdist=Math.sqrt(mdx*mdx+mdy*mdy);
          if(mdist<mouse.radius){
            ctx.beginPath(); ctx.moveTo(p.x,p.y); ctx.lineTo(mouse.x,mouse.y);
            ctx.strokeStyle='rgba(255,255,255,'+(1-mdist/mouse.radius)*0.6+')'; ctx.lineWidth=1; ctx.stroke();
            ctx.beginPath(); ctx.arc(p.x,p.y,p.r*1.8,0,Math.PI*2); ctx.fillStyle='rgba(255,255,255,0.9)'; ctx.fill();
          }
        }
      }
      requestAnimationFrame(draw);
    }
    draw();
  }
  $(document).on('shiny:connected', initParticles);
})();

(function(){
  var lastScroll = 0;
  window.addEventListener('scroll', function(){
    var nav = document.querySelector('nav.navbar.navbar-fixed-top');
    if(!nav) return;
    var current = window.scrollY;
    if (current > lastScroll && current > 80) { nav.classList.add('nav-hidden'); }
    else { nav.classList.remove('nav-hidden'); }
    lastScroll = current;
  });
})();
"

js_scroll_to <- "
Shiny.addCustomMessageHandler('scrollToItem', function(id) {
  setTimeout(function() {
    var el = document.getElementById(id);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
      el.style.transition = 'box-shadow .3s ease';
      el.style.boxShadow = '0 0 0 3px rgba(96,165,250,.6)';
      setTimeout(function(){ el.style.boxShadow = ''; }, 1500);
    }
  }, 400);
});
"

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Traduções----
labels <- list(
  pt = list(nav_inicio = "Início", nav_perfil = "Perfil", nav_experiencia = "Experiência",
            nav_projetos = "Projetos", nav_certificados = "Certificados", nav_contato = "Contato",
            btn_ver_projetos = "Ver Projetos", btn_ver_cv = "Ver Currículo", btn_fale_comigo = "Fale comigo",
            busca_placeholder = "Digite para buscar..."),
  en = list(nav_inicio = "Home", nav_perfil = "Profile", nav_experiencia = "Experience",
            nav_projetos = "Projects", nav_certificados = "Certificates", nav_contato = "Contact",
            btn_ver_projetos = "View Projects", btn_ver_cv = "View Resume", btn_fale_comigo = "Contact me",
            busca_placeholder = "Type to search..."),
  es = list(nav_inicio = "Inicio", nav_perfil = "Perfil", nav_experiencia = "Experiencia",
            nav_projetos = "Proyectos", nav_certificados = "Certificados", nav_contato = "Contacto",
            btn_ver_projetos = "Ver Proyectos", btn_ver_cv = "Ver Currículum", btn_fale_comigo = "Contáctame",
            busca_placeholder = "Escribe para buscar...")
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Base de Conteúdo----

## Perfil----
perfil <- list(
  nome = "Michel Lima",
  cargo = "Estatístico e Cientista de Dados em Formação",
  tagline = "EM DESENVOLVIMENTO", # "Transformando dados em decisões" - restaurar no futuro
  bio = "Bacharelando em Estatística e Ciência de Dados pela Universidade
  Federal de Ouro Preto (UFOP), com <em>background</em> em Ciências Econômicas e 
  experiência aplicada em consultoria estatística, iniciação científica e diagnóstico
  territorial. Atuo como Consultor Técnico em Estatística em projeto de doutoramento 
  internacional, analisando bases de dados multidimensionais para subsidiar decisões de
  pesquisa. Desenvolvo projeções populacionais para pequenas áreas e diagnósticos 
  sociodemográficos a partir de dados públicos (DATASUS, IBGE, CAGED), traduzindo 
  indicadores demográficos, epidemiológicos e socioeconômicos em insights acionáveis 
  para o planejamento público. Domínio de R, com aplicações em SQL e Shiny, além de 
  conhecimentos em Python e Power BI.",
  foto = "img/perfil.jpg",
  email = "michelescreva@gmail.com",
  linkedin = "https://www.linkedin.com/in/micheldeoliveira/",
  github = "https://github.com/michelolv",
  lattes = "http://lattes.cnpq.br/0000000000000000",
  localizacao = "Ouro Preto, MG - Brasil",
  cv_path = "cv/curriculo.pdf"
)

## Experiências (imagem: img/Experiência_<n>.png - so a 1 existe por enquanto)----
experiencias <- list(
  list(id="exp1", empresa="Nome da Empresa 1", cargo="Estagiário(a) de Dados", periodo="Mar/2024 - Atual", local="Remoto",
       descricao=c("Desenvolvimento de dashboards em R Shiny / Power BI para acompanhamento de KPIs.",
                   "Automatização de relatórios em R, reduzindo o tempo de entrega.",
                   "Aplicação de testes estatísticos e modelos exploratórios."),
       tecnologias=c("R","SQL","Power BI","Excel"), imagem="img/Experiência_1.png",
       saiba_mais_url="https://www.linkedin.com/in/micheldeoliveira/"),
  list(id="exp2", empresa="Empresa Fictícia LTDA", cargo="Analista de Dados Júnior", periodo="Jan/2023 - Fev/2024", local="Presencial",
       descricao=c("Construção de pipelines de tratamento e limpeza de dados em R.",
                   "Elaboração de relatórios gerenciais periódicos para diretoria.",
                   "Apoio na modelagem estatística de indicadores de desempenho."),
       tecnologias=c("R","Excel","SQL"), imagem="img/Experiência_2.png",
       saiba_mais_url="https://www.linkedin.com/in/micheldeoliveira/"),
  list(id="exp3", empresa="Instituto de Pesquisa XYZ", cargo="Bolsista de Iniciação Científica", periodo="Ago/2022 - Dez/2022", local="Híbrido",
       descricao=c("Análise exploratória de dados demográficos e socioeconômicos.",
                   "Suporte na produção de relatórios técnicos para publicação.",
                   "Participação em reuniões de acompanhamento de projeto de pesquisa."),
       tecnologias=c("R","Python","Excel"), imagem="img/Experiência_3.png",
       saiba_mais_url="https://www.linkedin.com/in/micheldeoliveira/")
)

## Projetos (tipo_grafico: barra / likert / rede)----
projetos <- list(
  list(id="proj1", titulo="Nome do Projeto 1", subtitulo="Curta descrição / objetivo do projeto",
       descricao=c("Contexto do problema e motivação.","Metodologia estatística/ML utilizada.","Principais resultados e conclusões."),
       tecnologias=c("R","ggplot2","Shiny"), link_github="https://github.com/seu-usuario/projeto1", link_demo=NA,
       tipo_grafico="barra", saiba_mais_url="https://github.com/seu-usuario/projeto1"),
  list(id="proj2", titulo="Dashboard de Indicadores Municipais", subtitulo="Painel interativo para acompanhamento de dados públicos",
       descricao=c("Integração de bases públicas (IBGE, DATASUS) em um único painel.","Visualizações dinâmicas para comparação entre municípios.","Publicação e hospedagem gratuita via Posit Connect Cloud."),
       tecnologias=c("R","Shiny","Plotly"), link_github="https://github.com/seu-usuario/projeto2", link_demo=NA,
       tipo_grafico="likert", saiba_mais_url="https://github.com/seu-usuario/projeto2"),
  list(id="proj3", titulo="Modelo Preditivo Fictício", subtitulo="Estudo de caso de classificação estatística",
       descricao=c("Preparação e balanceamento de base de dados de exemplo.","Comparação entre diferentes modelos estatísticos/ML.","Avaliação de desempenho com métricas de classificação."),
       tecnologias=c("R","tidymodels"), link_github="https://github.com/seu-usuario/projeto3", link_demo=NA,
       tipo_grafico="rede", saiba_mais_url="https://github.com/seu-usuario/projeto3")
)

## Certificados (logo: img/Empresa_<n>.png | certificado: img/Certificado_<n>.png - so o 1 existe por enquanto)----
certificados <- list(
  list(id="cert1", titulo="Nome do Certificado 1", instituicao="Instituição / Plataforma", carga_horaria="40h", ano="2024",
       descricao="Breve descrição do que foi aprendido no curso/certificação.", skills=c("R","Estatística"),
       logo_img="img/Empresa_1.png", certificado_img="img/Certificado_1.png",
       saiba_mais_url="https://www.coursera.org"),
  list(id="cert2", titulo="Estatística Aplicada com R", instituicao="Plataforma de Ensino Fictícia", carga_horaria="60h", ano="2023",
       descricao="Curso com foco em testes estatísticos, modelagem e visualização de dados em R.", skills=c("R","Testes Estatísticos","Visualização"),
       logo_img="img/Empresa_2.png", certificado_img="img/Certificado_2.png",
       saiba_mais_url="https://www.alura.com.br"),
  list(id="cert3", titulo="Fundamentos de Ciência de Dados", instituicao="Instituição Fictícia de Tecnologia", carga_horaria="80h", ano="2023",
       descricao="Formação introdutória cobrindo Python, SQL e fundamentos de Machine Learning.", skills=c("Python","SQL","Machine Learning"),
       logo_img="img/Empresa_3.png", certificado_img="img/Certificado_3.png",
       saiba_mais_url="https://www.udemy.com")
)

## Índice de busca----
indice_busca <- c(
  lapply(experiencias, function(x) list(id=x$id, titulo=x$empresa, categoria="Experiência", tab="experiencia")),
  lapply(projetos,     function(x) list(id=x$id, titulo=x$titulo,  categoria="Projeto",     tab="projetos")),
  lapply(certificados, function(x) list(id=x$id, titulo=x$titulo,  categoria="Certificado", tab="certificados"))
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Funções Auxiliares----

badge_tech <- function(techs) tagList(lapply(techs, function(t) span(class="tech-badge", t)))

## Grafico de barras (proj1)----
grafico_barras <- function() {
  df <- data.frame(metrica=c("Acurácia","Precisão","Recall","F1"), valor=c(88,82,79,80))
  p <- ggplot(df, aes(x=reorder(metrica,valor), y=valor, fill=valor)) +
    geom_col(width=0.6) + coord_flip() +
    scale_fill_gradient(low="#93c5fd", high="#1e3a8a") +
    theme_minimal(base_size=12) +
    theme(legend.position="none",
          plot.background=element_rect(fill="transparent", color=NA),
          panel.background=element_rect(fill="transparent", color=NA),
          text=element_text(color="#e5e7eb"), axis.text=element_text(color="#e5e7eb"),
          panel.grid.major=element_line(color="rgba(255,255,255,.08)"), panel.grid.minor=element_blank()) +
    labs(x=NULL, y=NULL)
  ggplotly(p) %>% layout(paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)", font=list(color="#e5e7eb"))
}

## Grafico Likert (proj2) - barras divergentes----
grafico_likert <- function() {
  df <- data.frame(
    afirmacao = rep(c("Usabilidade","Clareza dos dados","Utilidade prática"), each=2),
    lado      = rep(c("Negativo","Positivo"), 3),
    valor     = c(-20,80, -35,65, -15,85)
  )
  p <- ggplot(df, aes(x=afirmacao, y=valor, fill=lado)) +
    geom_col(width=0.55) + coord_flip() +
    scale_fill_manual(values=c("Negativo"="#f87171","Positivo"="#60a5fa")) +
    theme_minimal(base_size=12) +
    theme(legend.position="bottom", legend.title=element_blank(),
          plot.background=element_rect(fill="transparent", color=NA),
          panel.background=element_rect(fill="transparent", color=NA),
          text=element_text(color="#e5e7eb"), axis.text=element_text(color="#e5e7eb"),
          panel.grid.major=element_line(color="rgba(255,255,255,.08)"), panel.grid.minor=element_blank()) +
    labs(x=NULL, y=NULL)
  ggplotly(p) %>% layout(paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)", font=list(color="#e5e7eb"))
}

## Grafico de rede simples (proj3)----
grafico_rede <- function() {
  nos <- data.frame(id=c("A","B","C","D","E"), x=c(0,1,2,1,0.5), y=c(0,1,0,-1,-1.5))
  arestas <- data.frame(de=c("A","A","B","C","D"), para=c("B","D","C","D","E"))
  arestas <- merge(arestas, nos, by.x="de", by.y="id")
  names(arestas)[3:4] <- c("x1","y1")
  arestas <- merge(arestas, nos, by.x="para", by.y="id")
  names(arestas)[5:6] <- c("x2","y2")
  
  p <- plot_ly()
  for (i in seq_len(nrow(arestas))) {
    p <- add_trace(p, x=c(arestas$x1[i], arestas$x2[i]), y=c(arestas$y1[i], arestas$y2[i]),
                   type="scatter", mode="lines", line=list(color="rgba(148,163,184,.5)", width=1.5),
                   showlegend=FALSE, hoverinfo="none")
  }
  p <- add_trace(p, data=nos, x=~x, y=~y, type="scatter", mode="markers+text",
                 text=~id, textposition="top center", textfont=list(color="#e5e7eb"),
                 marker=list(size=18, color="#60a5fa"), showlegend=FALSE, hoverinfo="text")
  p %>% layout(
    paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
    xaxis=list(visible=FALSE), yaxis=list(visible=FALSE), font=list(color="#e5e7eb")
  )
}

## Bloco de imagem/grafico auxiliar (funcao onerror para esconder imagem quebrada)----
tag_img_segura <- function(src, alt="") {
  tags$img(src=src, alt=alt, onerror="this.style.display='none';")
}

## Bloco de Experiência----
bloco_experiencia <- function(exp) {
  div(id=exp$id, class="content-card",
      fluidRow(
        column(width=7,
               h3(exp$cargo, class="accent-text"), h5(paste0(exp$empresa," • ",exp$local)),
               div(class="periodo-tag", exp$periodo), tags$hr(),
               tags$ul(lapply(exp$descricao, tags$li)),
               h5("Tecnologias utilizadas:"), badge_tech(exp$tecnologias)
        ),
        column(width=5,
               div(class="side-media",
                   tag_img_segura(exp$imagem, exp$empresa),
                   div(class="side-actions",
                       tags$a(class="btn-outline-cta", href=exp$saiba_mais_url, target="_blank", "Leia mais \u2192")
                   )
               )
        )
      )
  )
}

## Bloco de Projeto----
bloco_projeto <- function(proj) {
  grafico_id <- paste0("plot_", proj$id)
  div(id=proj$id, class="content-card",
      fluidRow(
        column(width=7,
               h3(proj$titulo, class="accent-text"), h5(proj$subtitulo), tags$hr(),
               tags$ul(lapply(proj$descricao, tags$li)),
               h5("Tecnologias:"), badge_tech(proj$tecnologias)
        ),
        column(width=5,
               plotlyOutput(grafico_id, height="240px"),
               div(class="side-actions",
                   tags$a(class="btn-cta", href=proj$link_github, target="_blank", icon("github"), " Repositório"),
                   if (!is.na(proj$link_demo)) tags$a(class="btn-cta", href=proj$link_demo, target="_blank", icon("up-right-from-square")," Demo"),
                   tags$a(class="btn-outline-cta", href=proj$saiba_mais_url, target="_blank", "Leia mais \u2192")
               )
        )
      )
  )
}

## Bloco de Certificado----
bloco_certificado <- function(cert) {
  div(id=cert$id, class="content-card",
      fluidRow(
        column(width=7,
               h3(cert$titulo, class="accent-text"), h5(cert$instituicao),
               div(class="periodo-tag", paste(cert$ano,"•",cert$carga_horaria)), tags$hr(),
               p(cert$descricao), h5("Skills:"), badge_tech(cert$skills)
        ),
        column(width=5,
               div(class="cert-logo-box", tag_img_segura(cert$logo_img, cert$instituicao)),
               div(class="side-actions",
                   tags$a(class="btn-cta", href=cert$certificado_img, target="_blank", icon("file-lines")," Ver certificado"),
                   tags$a(class="btn-outline-cta", href=cert$saiba_mais_url, target="_blank", "Leia mais \u2192")
               )
        )
      )
  )
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Páginas de Categoria----

pagina_experiencia_completa <- function() {
  div(class="hub-page", style="padding: 10px 30px 30px 30px;",
      h2("Experiência Profissional", class="accent-text"),
      p("Um resumo de toda a minha trajetória profissional."), tags$hr(),
      lapply(experiencias, bloco_experiencia))
}
pagina_projetos_completa <- function() {
  div(class="hub-page", style="padding: 10px 30px 30px 30px;",
      h2("Meus Projetos", class="accent-text"),
      p("Uma seleção dos projetos que desenvolvi."), tags$hr(),
      lapply(projetos, bloco_projeto))
}
pagina_certificados_completa <- function() {
  div(class="hub-page", style="padding: 10px 30px 30px 30px;",
      h2("Certificados", class="accent-text"),
      p("Cursos e certificações concluídos."), tags$hr(),
      lapply(certificados, bloco_certificado))
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Páginas Fixas----

pagina_inicio <- function() {
  tagList(
    div(class="hero",
        tags$img(src=perfil$foto),
        h1(HTML(paste0("Olá, eu sou <span class='accent-text'>", perfil$nome, "</span>"))),
        p(class="subtitle", perfil$cargo),
        p(perfil$tagline),
        div(class="hero-actions",
            actionButton("btn_ver_projetos", labels$pt$btn_ver_projetos, class="btn-cta", icon=icon("diagram-project")),
            tags$a(class="btn btn-cta", href=perfil$cv_path, target="_blank", icon("file-lines")," ",labels$pt$btn_ver_cv),
            actionButton("btn_ir_contato", labels$pt$btn_fale_comigo, class="btn-cta", icon=icon("paper-plane"))
        )
    )
  )
}

pagina_perfil <- function() {
  fluidRow(style="padding: 10px 30px 30px 30px;",
           column(width=4,
                  div(class="content-card", style="text-align:center;",
                      tags$img(src=perfil$foto, style="width:160px;height:160px;border-radius:50%;object-fit:cover;border:3px solid #60a5fa;"),
                      h4(perfil$nome), h6(perfil$cargo),
                      p(icon("location-dot"), perfil$localizacao),
                      tags$a(icon("linkedin"), href=perfil$linkedin, target="_blank", style="margin:6px;color:#e5e7eb;"),
                      tags$a(icon("github"), href=perfil$github, target="_blank", style="margin:6px;color:#e5e7eb;"),
                      tags$a(icon("envelope"), href=paste0("mailto:",perfil$email), style="margin:6px;color:#e5e7eb;")
                  )
           ),
           column(width=8,
                  div(class="content-card", h3("Sobre mim", class="accent-text"), p(HTML(perfil$bio))),
                  div(class="content-card", h3("Formação Acadêmica", class="accent-text"),
                      p("Bacharelado: Estatística e Ciência de Dados, Universidade Federal de Ouro Preto (UFOP), 8º período."))
           )
  )
}

pagina_contato <- function() {
  fluidRow(style="padding: 10px 30px 30px 30px;",
           column(width=6,
                  div(class="content-card",
                      h3("Vamos conversar", class="accent-text"),
                      p(icon("envelope")," ", perfil$email),
                      p(icon("linkedin")," ", tags$a(href=perfil$linkedin, target="_blank", "LinkedIn", style="color:#93c5fd;")),
                      p(icon("github")," ", tags$a(href=perfil$github, target="_blank", "GitHub", style="color:#93c5fd;")),
                      p(icon("book")," ", tags$a(href=perfil$lattes, target="_blank", "Currículo Lattes", style="color:#93c5fd;"))
                  )
           ),
           column(width=6,
                  div(class="content-card modern-form",
                      h3("Envie uma mensagem", class="accent-text"),
                      fluidRow(
                        column(6, div(class="form-group", tags$label("Nome"), textInput("contato_nome", NULL, placeholder="Seu nome"))),
                        column(6, div(class="form-group", tags$label("E-mail"), textInput("contato_email", NULL, placeholder="seu@email.com")))
                      ),
                      div(class="form-group", tags$label("Mensagem"), textAreaInput("contato_msg", NULL, rows=4, placeholder="Escreva sua mensagem...")),
                      actionButton("btn_enviar_contato", "Enviar mensagem", class="btn-cta", icon=icon("paper-plane"))
                  )
           )
  )
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Barra de utilidades----

seletor_idioma <- pickerInput(
  inputId="idioma", label=NULL, choices=c("pt","en","es"), selected="pt", width="140px",
  options=list(width="140px"),
  choicesOpt=list(content=c(
    "<img src='https://flagcdn.com/24x18/br.png' style='width:24px;height:18px;vertical-align:middle;'> PT",
    "<img src='https://flagcdn.com/24x18/us.png' style='width:24px;height:18px;vertical-align:middle;'> EN",
    "<img src='https://flagcdn.com/24x18/es.png' style='width:24px;height:18px;vertical-align:middle;'> ES"
  ))
)

barra_utilidades <- tagList(
  actionButton("abrir_busca", label=tags$span(icon("magnifying-glass")), class="btn-icon-nav", title="Buscar no portfólio"),
  seletor_idioma,
  actionButton("toggle_dark",
               label=tagList(tags$span(id="icon_moon", icon("moon")), tags$span(id="icon_sun", icon("sun"), style="display:none;")),
               class="btn-icon-nav", title="Alternar modo claro/escuro")
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# UI----
ui <- navbarPage(
  title=div(class="navbar-utils", barra_utilidades),
  id="navbar_principal", theme=tema_app, collapsible=TRUE, position="fixed-top",
  header=tagList(
    useShinyjs(),
    tags$head(
      tags$link(rel="stylesheet", href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700;800&display=swap"),
      tags$style(HTML(css_custom)),
      tags$script(HTML(js_particles)),
      tags$script(HTML(js_scroll_to))
    ),
    tags$div(id="app-bg-gradient"),
    tags$canvas(id="particles-canvas")
  ),
  
  tabPanel(tags$span(id="lbl_inicio","Início"), value="inicio", pagina_inicio()),
  tabPanel(tags$span(id="lbl_perfil","Perfil"), value="perfil", pagina_perfil()),
  tabPanel(tags$span(id="lbl_experiencia","Experiência"), value="experiencia", pagina_experiencia_completa()),
  tabPanel(tags$span(id="lbl_projetos","Projetos"), value="projetos", pagina_projetos_completa()),
  tabPanel(tags$span(id="lbl_certificados","Certificados"), value="certificados", pagina_certificados_completa()),
  tabPanel(tags$span(id="lbl_contato","Contato"), value="contato", pagina_contato()),
  
  footer=tags$footer(class="app-footer",
                     p(paste0("© ", format(Sys.Date(),"%Y")," ", perfil$nome," — Portfólio em Estatística & Ciência de Dados")))
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Server----
server <- function(input, output, session) {
  
  observe({
    query <- parseQueryString(session$clientData$url_search)
    if (!is.null(query$aba)) updateNavbarPage(session, "navbar_principal", selected=query$aba)
  })
  observeEvent(input$navbar_principal, {
    updateQueryString(paste0("?aba=", input$navbar_principal), mode="push")
  }, ignoreInit=TRUE)
  
  modo_escuro <- reactiveVal(FALSE)
  observeEvent(input$toggle_dark, {
    novo_estado <- !modo_escuro(); modo_escuro(novo_estado)
    shinyjs::toggleClass(selector="body", class="dark-mode")
    shinyjs::toggle(id="icon_moon", condition=!novo_estado)
    shinyjs::toggle(id="icon_sun", condition=novo_estado)
  })
  
  observeEvent(input$idioma, {
    lg <- labels[[input$idioma]]
    for (nm in c("inicio","perfil","experiencia","projetos","certificados","contato")) {
      shinyjs::runjs(sprintf("var el=document.getElementById('lbl_%s'); if(el) el.textContent='%s';", nm, lg[[paste0("nav_",nm)]]))
    }
    updateActionButton(session, "btn_ver_projetos", label=lg$btn_ver_projetos)
    updateActionButton(session, "btn_ir_contato", label=lg$btn_fale_comigo)
  }, ignoreInit=TRUE)
  
  observeEvent(input$abrir_busca, {
    showModal(modalDialog(
      title="Buscar no portfólio",
      textInput("busca_txt", NULL, placeholder=labels$pt$busca_placeholder, width="100%"),
      uiOutput("resultados_busca"), easyClose=TRUE, footer=NULL
    ))
  })
  output$resultados_busca <- renderUI({
    req(nchar(input$busca_txt %||% "") > 0)
    termo <- tolower(input$busca_txt)
    encontrados <- Filter(function(x) grepl(termo, tolower(x$titulo)), indice_busca)
    if (length(encontrados)==0) return(p("Nenhum resultado encontrado."))
    tagList(lapply(encontrados, function(x) {
      div(class="search-result-item",
          onclick=sprintf("Shiny.setInputValue('busca_click', {id:'%s', tab:'%s'}, {priority:'event'})", x$id, x$tab),
          span(class="cat-tag", x$categoria), br(), strong(x$titulo))
    }))
  })
  observeEvent(input$busca_click, {
    updateNavbarPage(session, "navbar_principal", selected=input$busca_click$tab)
    session$sendCustomMessage("scrollToItem", input$busca_click$id)
    removeModal()
  })
  
  ## Graficos de projetos (dispatch por tipo)----
  lapply(projetos, function(proj) {
    local({
      proj_local <- proj
      output[[paste0("plot_", proj_local$id)]] <- renderPlotly({
        switch(proj_local$tipo_grafico,
               "barra"  = grafico_barras(),
               "likert" = grafico_likert(),
               "rede"   = grafico_rede())
      })
    })
  })
  
  observeEvent(input$btn_ver_projetos, { updateNavbarPage(session, "navbar_principal", selected="projetos") })
  observeEvent(input$btn_ir_contato, { updateNavbarPage(session, "navbar_principal", selected="contato") })
  observeEvent(input$btn_enviar_contato, { showNotification("Mensagem registrada! (integrar envio real de e-mail futuramente)", type="message") })
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Executar Aplicação----
shinyApp(ui, server)