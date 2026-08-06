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
  heading_font = font_google("Poppins"),
  code_font    = font_google("JetBrains Mono")
)

# CSS customizado----
css_custom <- "
  :root { --nav-accent: #2563eb; --underline-color: #9ca3af; }
  body.dark-mode { --nav-accent: #60a5fa; --underline-color: #9ca3af; }

  /* ===== Tipografia: 3 fontes por contexto ===== */
  h1, h2, h3, .hero h1, .accent-text {
    font-family: 'Lora', Georgia, serif;
  }
  .navbar .nav-link, .navbar .dropdown-toggle, .dropdown-item,
  .stat-box .lab, .periodo-tag, .tech-badge, .navbar-brand {
    font-family: 'Poppins', sans-serif !important;
  }
  body, p, li, .content-card, input, textarea, select, .btn {
    font-family: 'Inter', sans-serif;
  }

  body {
    padding-top: 200px;
    background-color: #f4f5f7;
    color: #1a1a1a;
  }

  /* Fundo com imagem apenas na pagina Inicio ---- */
  body.pagina-inicio {
    background-image:
      linear-gradient(180deg, rgba(244,245,247,.20) 0%, rgba(244,245,247,0) 20%, rgba(244,245,247,0) 68%, #f4f5f7 100%),
      url('img/capa-bg.jpg');
    background-size: cover;
    background-position: center top;
    background-attachment: fixed;
    background-repeat: no-repeat;
  }

  /* ===== Navbar flutuante, sem painel de fundo ===== */
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
    background-color: #ffffff !important;
    border-color: rgba(0,0,0,.08) !important;
    box-shadow: 0 10px 30px rgba(0,0,0,.12);
  }
  .navbar-collapse,
  .navbar-nav,
  .navbar .container-fluid {
    background: transparent !important;
  }
  @supports not ((backdrop-filter: blur(1px)) or (-webkit-backdrop-filter: blur(1px))) {
    nav.navbar.navbar-fixed-top { background-color: rgba(255,255,255,.55) !important; }
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
  .navbar-nav .nav-item.dropdown {
    position: relative !important;
  }
  .navbar-nav .dropdown-menu {
    position: absolute !important;
    top: 100% !important;
    left: 0 !important;
    margin-top: 18px !important;
    min-width: 220px !important;
    width: max-content !important;
    max-width: 320px !important;
  }
  .navbar-utils .dropdown-menu {
    margin-top: 19px !important;
  }

  /* ===== Icones das abas: garantir preenchimento pela cor do texto ===== */
  .navbar .nav-link svg,
  .navbar .nav-link svg path,
  .navbar-nav .dropdown-toggle svg,
  .navbar-nav .dropdown-toggle svg path {
    fill: currentColor !important;
  }
  

  /* ===== Cor e tamanho das abas ===== */
  .navbar .nav-link,
  .navbar-nav .dropdown-toggle {
    color: #ffffff !important;
    font-weight: 600;
    font-size: 1.05rem;
    text-shadow: 0 1px 5px rgba(0,0,0,.55);
    transition: color .2s ease;
    border-bottom: none !important;
    box-shadow: none !important;
    outline: none !important;
  }

  /* Modo claro: quando o painel fica branco (hover geral), o texto vira escuro ---- */
  body:not(.dark-mode) nav.navbar.navbar-fixed-top:hover .nav-link,
  body:not(.dark-mode) nav.navbar.navbar-fixed-top:hover .navbar-nav .dropdown-toggle {
    color: #111111 !important;
    text-shadow: none;
  }

  /* Hover individual do link: sempre cor de destaque, tem prioridade sobre a regra acima ---- */
  body:not(.dark-mode) nav.navbar.navbar-fixed-top:hover .nav-link:hover,
  body:not(.dark-mode) nav.navbar.navbar-fixed-top:hover .navbar-nav .dropdown-toggle:hover,
  .navbar .nav-link:hover,
  .navbar-nav .dropdown-toggle:hover {
    color: var(--nav-accent) !important;
    text-shadow: none;
  }

  .navbar .nav-link:not(.dropdown-toggle) {
    position: relative;
  }
  .navbar .nav-link:not(.dropdown-toggle)::after {
    content: '';
    position: absolute;
    left: 50%; bottom: -2px;
    width: 0%; height: 2px;
    background: var(--underline-color);
    transition: width .25s ease, left .25s ease;
  }
  .navbar .nav-link:not(.dropdown-toggle):hover::after,
  .navbar .nav-link:not(.dropdown-toggle).active::after {
    width: 70%; left: 15%;
  }
  
  .navbar-nav .dropdown-toggle {
    position: relative;
  }
  .navbar-nav .dropdown-toggle::before {
    content: '';
    position: absolute;
    left: 50%; bottom: -2px;
    width: 0%; height: 2px;
    background: var(--underline-color);
    transition: width .25s ease, left .25s ease;
  }
  .navbar-nav .dropdown-toggle:hover::before,
  .navbar-nav .nav-item.dropdown.show .dropdown-toggle::before {
    width: 70%; left: 15%;
  }
  
  .navbar .nav-link.active,
  .navbar .show > .nav-link,
  .navbar .dropdown-toggle.active {
    font-weight: 700 !important;
    border-bottom: none !important;
    box-shadow: none !important;
  }
  .navbar-nav .nav-item .nav-link.active,
  .navbar-nav .nav-item.dropdown.show .nav-link {
    border-bottom-color: transparent !important;
    -webkit-box-shadow: none !important;
    box-shadow: none !important;
  }

  /* ===== Sub-abas (dropdown): mesma fonte das categorias, tamanho controlado ===== */
  .dropdown-menu {
    border-radius: 10px;
    box-shadow: 0 6px 20px rgba(0,0,0,.10);
  }
  
  .navbar-nav .dropdown-menu,
  .navbar-utils .dropdown-menu {
    background-color: rgba(255,255,255,.55) !important;
    border: 1px solid rgba(255,255,255,.4) !important;
    transition: background-color .25s ease, border-color .25s ease;
  }
  .navbar-utils .bs-searchbox,
  .navbar-utils .bs-actionsbox,
  .navbar-utils .bs-donebutton,
  .navbar-utils .no-results {
    display: none !important;
  }
  
  /* Impede dupla camada de transparencia: o bootstrap-select usa 2 elementos
     com classe dropdown-menu (o envolucro externo e a lista .inner interna).
     Apenas o externo deve ter fundo/borda; o interno fica neutro. ---- */
  .navbar-utils .dropdown-menu.inner {
    background: transparent !important;
    border: none !important;
    box-shadow: none !important;
    margin: 0 !important;
    padding: 4px 0 !important;
  }
  
  nav.navbar.navbar-fixed-top:hover .navbar-nav .dropdown-menu,
  nav.navbar.navbar-fixed-top:hover .navbar-utils .dropdown-menu,
  .navbar-nav .dropdown-menu:hover,
  .navbar-utils .dropdown-menu:hover {
    background-color: #ffffff !important;
    border-color: rgba(0,0,0,.08) !important;
  }
  .dropdown-item {
    color: #111111 !important;
    font-family: 'Poppins', sans-serif !important;
    font-size: .92rem !important;
    font-weight: 500 !important;
  }
  .dropdown-item:hover {
    background-color: rgba(37,99,235,.08) !important;
    color: #2563eb !important;
  }
  .dropdown-divider { border-color: rgba(0,0,0,.08); }

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

  /* Remove o invólucro branco/com borda que o bootstrap-select adiciona por padrao ---- */
  .navbar-utils .bootstrap-select.form-control,
  .navbar-utils .bootstrap-select .dropdown-toggle.form-control {
    background: transparent !important;
    border: none !important;
    box-shadow: none !important;
  }

  /* Botoes de icone (lupa / modo escuro): brancos por padrao ---- */
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
  nav.navbar.navbar-fixed-top:hover .btn-icon-nav {
    background: #ffffff !important;
  }
  /* Quando o painel fica branco (modo claro), os icones escurecem para continuar visiveis ---- */
  body:not(.dark-mode) nav.navbar.navbar-fixed-top:hover .btn-icon-nav {
    color: #111111 !important;
    border-color: rgba(0,0,0,.15) !important;
  }
  .btn-icon-nav:hover {
    border-color: var(--nav-accent) !important;
  }
  
  /* Hover no botao (qualquer icone interno, com ou sem id) vira azul ---- */
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

  /* Botao de idioma: branco por padrao, escurece com o painel, azul no hover proprio ---- */
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
    background: #ffffff !important;
  }
  body:not(.dark-mode) nav.navbar.navbar-fixed-top:hover .navbar-utils .dropdown-toggle.btn-light {
    color: #111111 !important;
    border-color: rgba(0,0,0,.15) !important;
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
  .navbar-utils .dropdown-toggle.btn-light:hover .filter-option-inner-inner,
  .navbar-utils .dropdown-toggle.btn-light:hover .filter-option-inner-inner * {
    color: #2563eb !important;
  }
  body.dark-mode .navbar-utils .dropdown-toggle.btn-light:hover .filter-option-inner-inner,
  body.dark-mode .navbar-utils .dropdown-toggle.btn-light:hover .filter-option-inner-inner * {
    color: var(--nav-accent) !important;
  }
  .navbar-utils .dropdown-toggle.btn-light:focus,
  .navbar-utils .dropdown-toggle.btn-light:active,
  .navbar-utils .dropdown-toggle.btn-light.show {
    outline: none !important;
    box-shadow: none !important;
    border-color: rgba(255,255,255,.4) !important;
  }
  .navbar-utils .filter-option-inner-inner { color: inherit !important; }

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

  .content-card {
    background-color: #ffffff;
    border-radius: 16px;
    padding: 28px;
    margin-bottom: 22px;
    border: 1px solid rgba(0,0,0,.06);
    box-shadow: 0 4px 18px rgba(0,0,0,.06);
    transition: background-color .25s ease, border-color .25s ease;
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

  .hero { text-align: center; padding: 90px 20px 40px 20px; }
  .hero img {
    width: 190px; height: 190px; object-fit: cover;
    border-radius: 50%;
    border: 4px solid #9ca3af;
    box-shadow: 0 0 35px rgba(156,163,175,.35);
    margin-top: -30px;
  }
  .hero h1 { font-size: 2.6rem; margin-top: 22px; color: #111111; }
  .hero p.subtitle { color: #374151; font-size: 1.2rem; font-family: 'Poppins', sans-serif; }

  /* ===== Cards de estatistica (Inicio): transparentes, brancos no hover ===== */
  .stat-box {
    background-color: transparent;
    border-radius: 14px;
    padding: 22px;
    text-align: center;
    border: 1px solid rgba(255,255,255,.4);
    box-shadow: none;
    transition: background-color .25s ease, border-color .25s ease, box-shadow .25s ease;
  }
  .stat-box:hover {
    background-color: #ffffff;
    border-color: rgba(0,0,0,.06);
    box-shadow: 0 4px 14px rgba(0,0,0,.05);
  }
  .stat-box .num {
    font-size: 2rem; font-weight: 700; color: #ffffff;
    font-family: 'Lora', serif; transition: color .25s ease;
  }
  .stat-box .lab { color: #ffffff; font-size: .9rem; transition: color .25s ease; }
  .stat-box:hover .num,
  .stat-box:hover .lab { color: #111111 !important; }

  /* ===== Botoes de acao (CTA): gradiente cinza ===== */
  .btn-cta {
    background: linear-gradient(90deg, #9ca3af, #4b5563);
    border: none; color: #ffffff; font-weight: 600;
    padding: 10px 26px; border-radius: 30px; margin: 6px;
    font-family: 'Poppins', sans-serif;
  }
  .btn-cta:hover { opacity: .88; color: #ffffff; }

  footer.app-footer {
    text-align: center; padding: 30px; color: #6b7280;
    border-top: 1px solid rgba(0,0,0,.06); margin-top: 40px;
  }

  .cert-img { max-width: 100%; border-radius: 10px; border: 1px solid rgba(0,0,0,.08); }

  .search-result-item {
    padding: 10px 14px; border-radius: 8px; cursor: pointer;
    border: 1px solid rgba(0,0,0,.06); margin-bottom: 6px;
  }
  .search-result-item:hover { background-color: rgba(37,99,235,.08); }
  .search-result-item .cat-tag { font-size: .75rem; color: #6b7280; }

  /* ===== MODO ESCURO ===== */
  body.dark-mode { background-color: #0f1115; color: #e5e7eb; }
  body.dark-mode.pagina-inicio {
    background-image:
      linear-gradient(180deg, rgba(15,17,21,.20) 0%, rgba(15,17,21,0) 20%, rgba(15,17,21,0) 68%, #0f1115 100%),
      url('img/capa-bg.jpg');
  }
  body.dark-mode nav.navbar.navbar-fixed-top,
  body.dark-mode nav.navbar.navbar-fixed-top[class*='bg-'] {
    background-color: rgba(20,22,28,.35) !important;
    border-color: rgba(255,255,255,.12) !important;
  }
  body.dark-mode nav.navbar.navbar-fixed-top:hover,
  body.dark-mode nav.navbar.navbar-fixed-top[class*='bg-']:hover { background-color: #14161c !important; }

  /* Todas as abas ficam claras no modo escuro, inclusive no hover do painel ---- */
  body.dark-mode .navbar .nav-link,
  body.dark-mode .navbar-nav .dropdown-toggle {
    color: #e5e7eb !important;
    text-shadow: 0 1px 4px rgba(0,0,0,.7);
  }
  body.dark-mode .navbar .nav-link:hover,
  body.dark-mode .navbar-nav .dropdown-toggle:hover {
    color: var(--nav-accent) !important;
  }

  body.dark-mode .navbar-nav .dropdown-menu,
  body.dark-mode .navbar-utils .dropdown-menu {
    background-color: rgba(20,22,28,.65) !important;
    border-color: rgba(255,255,255,.15) !important;
  }
  
  body.dark-mode nav.navbar.navbar-fixed-top:hover .navbar-nav .dropdown-menu,
  body.dark-mode nav.navbar.navbar-fixed-top:hover .navbar-utils .dropdown-menu,
  body.dark-mode .navbar-nav .dropdown-menu:hover,
  body.dark-mode .navbar-utils .dropdown-menu:hover {
    background-color: #14161c !important;
    border-color: rgba(255,255,255,.12) !important;
  }
  body.dark-mode .dropdown-item { color: #e5e7eb !important; }

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

  body.dark-mode .content-card,
  body.dark-mode .stat-box { background-color: #171922; border-color: rgba(255,255,255,.06); }
  body.dark-mode .hero h1 { color: #f3f4f6; }
  body.dark-mode .hero p.subtitle { color: #9ca3af; }
  body.dark-mode footer.app-footer { color: #9ca3af; border-color: rgba(255,255,255,.06); }
  body.dark-mode .stat-box:hover {
    background-color: #ffffff !important;
    border-color: rgba(0,0,0,.06) !important;
  }
  
"

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Traduções (infraestrutura pronta - conteudo livre ainda so em PT)----
labels <- list(
  pt = list(nav_inicio = "Início", nav_perfil = "Perfil", nav_experiencia = "Experiência",
            nav_projetos = "Projetos", nav_certificados = "Certificados",
            nav_habilidades = "Habilidades", nav_contato = "Contato",
            btn_ver_projetos = "Ver Projetos", btn_baixar_cv = "Baixar CV", btn_fale_comigo = "Fale comigo",
            busca_placeholder = "Digite para buscar..."),
  en = list(nav_inicio = "Home", nav_perfil = "Profile", nav_experiencia = "Experience",
            nav_projetos = "Projects", nav_certificados = "Certificates",
            nav_habilidades = "Skills", nav_contato = "Contact",
            btn_ver_projetos = "View Projects", btn_baixar_cv = "Download CV", btn_fale_comigo = "Contact me",
            busca_placeholder = "Type to search..."),
  es = list(nav_inicio = "Inicio", nav_perfil = "Perfil", nav_experiencia = "Experiencia",
            nav_projetos = "Proyectos", nav_certificados = "Certificados",
            nav_habilidades = "Habilidades", nav_contato = "Contacto",
            btn_ver_projetos = "Ver Proyectos", btn_baixar_cv = "Descargar CV", btn_fale_comigo = "Contáctame",
            busca_placeholder = "Escribe para buscar...")
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Base de Conteúdo (PREENCHER AOS POUCOS)----

## Perfil----
perfil <- list(
  nome        = "Michel Lima",
  cargo       = "Estatístico e Cientista de Dados em Formação",
  tagline     = "Transformando dados em decisões",
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
  cv_path     = "www/cv/curriculo.pdf"
)

## Habilidades técnicas (para gráfico radar)----
habilidades_tecnicas <- data.frame(
  habilidade = c("R", "Python", "SQL", "Power BI", "Estatística", "Machine Learning", "Excel", "Git"),
  nivel      = c(90, 70, 75, 65, 85, 60, 80, 65)
)

## Experiências de trabalho (cada item = uma sub-aba)----
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
    tecnologias = c("R", "SQL", "Power BI", "Excel"),
    grafico     = data.frame(
      tecnologia     = c("R", "SQL", "Power BI", "Excel"),
      uso_percentual = c(90, 60, 70, 50)
    )
  )
  # , list(id = "exp2", empresa = "...", ...)
)

## Projetos diversos (cada item = uma sub-aba)----
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
    tecnologias = c("R", "ggplot2", "Shiny"),
    link_github = "https://github.com/seu-usuario/projeto1",
    link_demo   = NA,
    grafico     = data.frame(
      metrica = c("Acurácia", "Precisão", "Recall", "F1"),
      valor   = c(88, 82, 79, 80)
    )
  )
  # , list(id = "proj2", titulo = "...", ...)
)

## Certificados (cada item = uma sub-aba, com PDF anexado)----
certificados <- list(
  list(
    id            = "cert1",
    titulo        = "Nome do Certificado 1",
    instituicao   = "Instituição / Plataforma",
    carga_horaria = "40h",
    ano           = "2024",
    descricao     = "Breve descrição do que foi aprendido no curso/certificação.",
    pdf           = "certificados/cert1.pdf"
  )
  # , list(id = "cert2", titulo = "...", ...)
)

## Índice combinado para a busca----
indice_busca <- c(
  lapply(experiencias, function(x) list(id = x$id, titulo = x$empresa, categoria = "Experiência")),
  lapply(projetos,     function(x) list(id = x$id, titulo = x$titulo,  categoria = "Projeto")),
  lapply(certificados, function(x) list(id = x$id, titulo = x$titulo,  categoria = "Certificado"))
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Funções Auxiliares----

## Badges de tecnologia----
badge_tech <- function(techs) {
  tagList(lapply(techs, function(t) span(class = "tech-badge", t)))
}

## Gráfico de barras (stack de tecnologias / métricas)----
grafico_barras <- function(df, titulo = "") {
  names(df) <- c("categoria", "valor")
  p <- ggplot(df, aes(x = reorder(categoria, valor), y = valor, fill = valor)) +
    geom_col(width = 0.6) +
    coord_flip() +
    scale_fill_gradient(low = "#93c5fd", high = "#1e3a8a") +
    theme_minimal(base_size = 13) +
    theme(
      legend.position   = "none",
      plot.background   = element_rect(fill = "transparent", color = NA),
      panel.background  = element_rect(fill = "transparent", color = NA),
      text              = element_text(color = "#1a1a1a"),
      axis.text         = element_text(color = "#1a1a1a"),
      panel.grid.major  = element_line(color = "rgba(0,0,0,.06)"),
      panel.grid.minor  = element_blank()
    ) +
    labs(x = NULL, y = NULL, title = titulo)
  
  ggplotly(p) %>%
    layout(
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor  = "rgba(0,0,0,0)",
      font          = list(color = "#1a1a1a")
    )
}

## Conversão de PDFs de certificados em imagem (executa 1x no boot)----
converter_certificados_png <- function(lista_certificados) {
  png_dir <- "www/certificados/png"
  if (!dir.exists(png_dir)) dir.create(png_dir, recursive = TRUE)
  
  for (cert in lista_certificados) {
    pdf_path <- file.path("www", cert$pdf)
    png_path <- file.path(png_dir, paste0(cert$id, ".png"))
    if (file.exists(pdf_path) && !file.exists(png_path)) {
      tryCatch(
        pdftools::pdf_convert(pdf_path, format = "png", pages = 1, dpi = 150, filenames = png_path),
        error = function(e) message("Falha ao converter ", cert$id, ": ", e$message)
      )
    }
  }
}
converter_certificados_png(certificados)

## Card de listagem (hub) - usado nas paginas "Ver todos"----
gerar_card_hub <- function(id_item, titulo, subtitulo = NULL) {
  div(
    class = "content-card",
    h4(titulo, class = "accent-text"),
    if (!is.null(subtitulo)) p(subtitulo),
    actionButton(paste0("goto_", id_item), "Ver detalhes \u2192", class = "btn-cta")
  )
}

## Página de Experiência (sub-aba)----
gerar_pagina_experiencia <- function(exp) {
  tabPanel(
    title = exp$empresa,
    value = exp$id,
    fluidRow(
      column(
        width = 7,
        div(
          class = "content-card",
          h3(exp$cargo, class = "accent-text"),
          h5(paste0(exp$empresa, " • ", exp$local)),
          div(class = "periodo-tag", exp$periodo),
          tags$hr(),
          tags$ul(lapply(exp$descricao, tags$li)),
          h5("Tecnologias utilizadas:"),
          badge_tech(exp$tecnologias)
        )
      ),
      column(
        width = 5,
        div(
          class = "content-card",
          h5("Stack utilizada"),
          plotlyOutput(outputId = paste0("plot_", exp$id), height = "320px")
        )
      )
    )
  )
}

## Página de Projeto (sub-aba)----
gerar_pagina_projeto <- function(proj) {
  tabPanel(
    title = proj$titulo,
    value = proj$id,
    fluidRow(
      column(
        width = 7,
        div(
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
                   icon("up-right-from-square"), " Demo")
        )
      ),
      column(
        width = 5,
        div(
          class = "content-card",
          h5("Resultados / Métricas"),
          plotlyOutput(outputId = paste0("plot_", proj$id), height = "320px")
        )
      )
    )
  )
}

## Página de Certificado (sub-aba)----
gerar_pagina_certificado <- function(cert) {
  png_path <- file.path("certificados/png", paste0(cert$id, ".png"))
  tabPanel(
    title = cert$titulo,
    value = cert$id,
    fluidRow(
      column(
        width = 5,
        div(
          class = "content-card",
          h3(cert$titulo, class = "accent-text"),
          h5(cert$instituicao),
          div(class = "periodo-tag", paste(cert$ano, "•", cert$carga_horaria)),
          tags$hr(),
          p(cert$descricao),
          downloadButton(paste0("download_", cert$id), "Baixar PDF original", class = "btn-cta")
        )
      ),
      column(
        width = 7,
        div(
          class = "content-card",
          if (file.exists(file.path("www", png_path)))
            tags$img(class = "cert-img", src = png_path)
          else
            p("Pré-visualização indisponível. Adicione o PDF em www/", cert$pdf)
        )
      )
    )
  )
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Páginas "Hub" (visão geral / listagem)----

pagina_experiencias_home <- function() {
  div(
    style = "padding: 30px;",
    h2("Experiência Profissional", class = "accent-text"),
    p("Um resumo de toda a minha trajetória. Clique em um item para ver os detalhes completos."),
    tags$hr(),
    fluidRow(lapply(experiencias, function(exp) {
      column(width = 4, gerar_card_hub(exp$id, exp$empresa, paste0(exp$cargo, " • ", exp$periodo)))
    }))
  )
}

pagina_projetos_home <- function() {
  div(
    style = "padding: 30px;",
    h2("Meus Projetos", class = "accent-text"),
    p("Uma seleção dos projetos que desenvolvi. Clique em um item para ver os detalhes completos."),
    tags$hr(),
    fluidRow(lapply(projetos, function(proj) {
      column(width = 4, gerar_card_hub(proj$id, proj$titulo, proj$subtitulo))
    }))
  )
}

pagina_certificados_home <- function() {
  div(
    style = "padding: 30px;",
    h2("Certificados", class = "accent-text"),
    p("Cursos e certificações concluídos. Clique em um item para ver os detalhes completos."),
    tags$hr(),
    fluidRow(lapply(certificados, function(cert) {
      column(width = 4, gerar_card_hub(cert$id, cert$titulo, paste0(cert$instituicao, " • ", cert$ano)))
    }))
  )
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Páginas Fixas (Início, Perfil, Habilidades, Contato)----

pagina_inicio <- function() {
  tagList(
    div(
      class = "hero",
      tags$img(src = perfil$foto),
      h1(HTML(paste0("Olá, eu sou <span class='accent-text'>", perfil$nome, "</span>"))),
      p(class = "subtitle", perfil$cargo),
      p(perfil$tagline),
      actionButton("btn_ver_projetos", labels$pt$btn_ver_projetos, class = "btn-cta", icon = icon("diagram-project")),
      downloadButton("btn_download_cv", labels$pt$btn_baixar_cv, class = "btn-cta"),
      actionButton("btn_ir_contato", labels$pt$btn_fale_comigo, class = "btn-cta", icon = icon("paper-plane"))
    ),
    fluidRow(
      style = "max-width: 900px; margin: 30px auto;",
      column(4, div(class = "stat-box", div(class = "num", length(experiencias)), div(class = "lab", "Experiências"))),
      column(4, div(class = "stat-box", div(class = "num", length(projetos)), div(class = "lab", "Projetos"))),
      column(4, div(class = "stat-box", div(class = "num", length(certificados)), div(class = "lab", "Certificados")))
    )
  )
}

pagina_perfil <- function() {
  fluidRow(
    style = "padding: 30px;",
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
          p("Bacharelado: Estatística e Ciência de Dados, Universidade Federal de Ouro Preto (UFOP), 8º período.")),
      div(class = "content-card", h3("Idiomas", class = "accent-text"),
          p("Inglês: Intermediário - Leitura técnica e escrita."))
    )
  )
}

pagina_habilidades <- function() {
  fluidRow(
    style = "padding: 30px;",
    column(6, div(class = "content-card", h3("Radar de Competências", class = "accent-text"),
                  plotlyOutput("radar_habilidades", height = "420px"))),
    column(6, div(class = "content-card", h3("Ferramentas & Linguagens", class = "accent-text"),
                  badge_tech(habilidades_tecnicas$habilidade)))
  )
}

pagina_contato <- function() {
  fluidRow(
    style = "padding: 30px;",
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

## Seletor de idioma com bandeiras reais (imagem), funciona em qualquer SO----
seletor_idioma <- pickerInput(
  inputId  = "idioma",
  label    = NULL,
  choices  = c("pt", "en", "es"),
  selected = "pt",
  width    = "140px",
  
  options = list(
    width = "140px"
  ),
  
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
                href = "https://fonts.googleapis.com/css2?family=Lora:wght@500;600;700&display=swap"),
      tags$style(HTML(css_custom)),
      tags$script(HTML("
        $(document).on('shiny:connected', function() {
          $('.navbar-nav i.far').removeClass('far').addClass('fas');
        });
      "))
    )
  ),
  
  tabPanel(tagList(icon("house"), tags$span(id = "lbl_inicio", "Início")), value = "inicio", pagina_inicio()),
  tabPanel(tagList(icon("user"), tags$span(id = "lbl_perfil", "Perfil")), value = "perfil", pagina_perfil()),
  
  do.call(navbarMenu, c(
    list(title = tagList(icon("briefcase"), tags$span(id = "lbl_experiencia", "Experiência"))),
    list(tabPanel("Todas as Experiências", value = "experiencias_home", icon = icon("list"), pagina_experiencias_home())),
    list("----"),
    lapply(experiencias, gerar_pagina_experiencia)
  )),
  
  do.call(navbarMenu, c(
    list(title = tagList(icon("diagram-project"), tags$span(id = "lbl_projetos", "Projetos"))),
    list(tabPanel("Todos os Projetos", value = "projetos_home", icon = icon("list"), pagina_projetos_home())),
    list("----"),
    lapply(projetos, gerar_pagina_projeto)
  )),
  
  do.call(navbarMenu, c(
    list(title = tagList(icon("certificate"), tags$span(id = "lbl_certificados", "Certificados"))),
    list(tabPanel("Todos os Certificados", value = "certificados_home", icon = icon("list"), pagina_certificados_home())),
    list("----"),
    lapply(certificados, gerar_pagina_certificado)
  )),
  
  tabPanel(tagList(icon("chart-simple"), tags$span(id = "lbl_habilidades", "Habilidades")), value = "habilidades", pagina_habilidades()),
  tabPanel(tagList(icon("envelope"), tags$span(id = "lbl_contato", "Contato")), value = "contato", pagina_contato()),
  
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
  
  ## Imagem de fundo (hero) somente na pagina Inicio----
  observeEvent(input$navbar_principal, {
    if (input$navbar_principal == "inicio") {
      shinyjs::runjs("document.body.classList.add('pagina-inicio');")
    } else {
      shinyjs::runjs("document.body.classList.remove('pagina-inicio');")
    }
  })
  
  ## Navegação a partir dos cards das páginas "Ver todos"----
  lapply(c(experiencias, projetos, certificados), function(item) {
    local({
      item_id <- item$id
      observeEvent(input[[paste0("goto_", item_id)]], {
        updateNavbarPage(session, "navbar_principal", selected = item_id)
      }, ignoreInit = TRUE)
    })
  })
  
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
    for (nm in c("inicio", "perfil", "experiencia", "projetos", "certificados", "habilidades", "contato")) {
      shinyjs::runjs(sprintf(
        "var el = document.getElementById('lbl_%s'); if (el) el.textContent = '%s';",
        nm, lg[[paste0("nav_", nm)]]
      ))
    }
    updateActionButton(session, "btn_ver_projetos", label = lg$btn_ver_projetos)
    updateActionButton(session, "btn_ir_contato",  label = lg$btn_fale_comigo)
  }, ignoreInit = TRUE)
  
  ## Busca----
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
        onclick = sprintf("Shiny.setInputValue('busca_click', '%s', {priority:'event'})", x$id),
        span(class = "cat-tag", x$categoria), br(), strong(x$titulo)
      )
    }))
  })
  
  observeEvent(input$busca_click, {
    updateNavbarPage(session, "navbar_principal", selected = input$busca_click)
    removeModal()
  })
  
  ## Gráficos de Experiências----
  lapply(experiencias, function(exp) {
    local({
      exp_local <- exp
      output[[paste0("plot_", exp_local$id)]] <- renderPlotly({ grafico_barras(exp_local$grafico, "") })
    })
  })
  
  ## Gráficos de Projetos----
  lapply(projetos, function(proj) {
    local({
      proj_local <- proj
      output[[paste0("plot_", proj_local$id)]] <- renderPlotly({ grafico_barras(proj_local$grafico, "") })
    })
  })
  
  ## Downloads de Certificados----
  lapply(certificados, function(cert) {
    local({
      cert_local <- cert
      output[[paste0("download_", cert_local$id)]] <- downloadHandler(
        filename = function() paste0(cert_local$id, ".pdf"),
        content  = function(file) file.copy(file.path("www", cert_local$pdf), file)
      )
    })
  })
  
  ## Radar de Habilidades----
  output$radar_habilidades <- renderPlotly({
    plot_ly(
      type = "scatterpolar", r = habilidades_tecnicas$nivel,
      theta = habilidades_tecnicas$habilidade, fill = "toself",
      line = list(color = "#2563eb"), fillcolor = "rgba(37,99,235,.15)"
    ) %>%
      layout(
        polar = list(radialaxis = list(visible = TRUE, range = c(0, 100), color = "#1a1a1a"), bgcolor = "rgba(0,0,0,0)"),
        paper_bgcolor = "rgba(0,0,0,0)", font = list(color = "#1a1a1a"), showlegend = FALSE
      )
  })
  
  ## Download do CV----
  output$btn_download_cv <- downloadHandler(
    filename = function() "curriculo.pdf",
    content  = function(file) file.copy(perfil$cv_path, file)
  )
  
  ## Navegação via botões da capa----
  observeEvent(input$btn_ver_projetos, {
    updateNavbarPage(session, "navbar_principal", selected = "projetos_home")
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