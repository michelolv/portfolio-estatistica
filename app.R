# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Pacotes----
library("pacman")
p_load(
  shiny, bslib, shinyWidgets, shinyjs, fontawesome,
  ggplot2, plotly, dplyr,
  pdftools, magick, DT, htmltools
)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Tema Visual (Dark / Tech)----
tema_app <- bs_theme(
  version      = 5,
  bg           = "#0b0f19",
  fg           = "#c9d1d9",
  primary      = "#00f5d4",
  secondary    = "#7b2ff7",
  success      = "#00e676",
  warning      = "#ffb020",
  danger       = "#ff5470",
  base_font    = font_google("Inter"),
  heading_font = font_google("Poppins"),
  code_font    = font_google("JetBrains Mono")
)

# CSS customizado (glow, cards, badges, hero, navbar)----
css_custom <- "
  body { padding-top: 70px; }

  /* Navbar: marca fixa a direita, menu centralizado ---- */
  .navbar .container-fluid {
    display: flex;
    align-items: center;
    position: relative;
  }
  .navbar-brand {
    order: 2;
    margin-left: auto !important;
    white-space: nowrap;
  }
  .navbar-toggler {
    order: 3;
  }
  .navbar-collapse {
    order: 1;
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
  }
  @media (max-width: 991.98px) {
    .navbar-collapse { position: static; transform: none; }
    .navbar-brand { order: 1; margin-left: 0 !important; }
    .navbar-toggler { order: 2; }
  }

  .navbar {
    background-color: #0b0f19 !important;
    border-bottom: 1px solid rgba(255,255,255,.08);
  }
  .navbar-brand, .nav-link { color: #c9d1d9 !important; font-weight: 500; }
  .nav-link:hover, .navbar-brand:hover { color: #00f5d4 !important; }
  .dropdown-menu { background-color: #141a29 !important; border: 1px solid rgba(255,255,255,.08); }
  .dropdown-item { color: #c9d1d9 !important; }
  .dropdown-item:hover { background-color: rgba(0,245,212,.12) !important; color: #00f5d4 !important; }
  .dropdown-divider { border-color: rgba(255,255,255,.08); }

  .accent-text {
    background: linear-gradient(90deg, #00f5d4, #7b2ff7);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    font-weight: 700;
  }

  .content-card {
    background-color: #141a29;
    border-radius: 16px;
    padding: 28px;
    margin-bottom: 22px;
    border: 1px solid rgba(255,255,255,.06);
    box-shadow: 0 4px 22px rgba(0,0,0,.45);
  }

  .tech-badge {
    display: inline-block;
    background: rgba(0,245,212,.12);
    color: #00f5d4;
    border: 1px solid #00f5d4;
    padding: 4px 12px;
    border-radius: 20px;
    margin: 3px;
    font-size: .8rem;
    font-family: 'JetBrains Mono', monospace;
  }

  .periodo-tag {
    display: inline-block;
    background: rgba(123,47,247,.15);
    color: #c9a9ff;
    padding: 3px 12px;
    border-radius: 6px;
    font-size: .85rem;
    margin-bottom: 10px;
  }

  .hero {
    text-align: center;
    padding: 70px 20px 40px 20px;
  }
  .hero img {
    width: 190px; height: 190px; object-fit: cover;
    border-radius: 50%;
    border: 4px solid #00f5d4;
    box-shadow: 0 0 35px rgba(0,245,212,.45);
  }
  .hero h1 { font-size: 2.6rem; margin-top: 22px; }
  .hero p.subtitle { color: #8b95a7; font-size: 1.2rem; }

  .stat-box {
    background-color: #141a29;
    border-radius: 14px;
    padding: 22px;
    text-align: center;
    border: 1px solid rgba(255,255,255,.06);
  }
  .stat-box .num { font-size: 2rem; font-weight: 700; color: #00f5d4; }
  .stat-box .lab { color: #8b95a7; font-size: .9rem; }

  .btn-cta {
    background: linear-gradient(90deg, #00f5d4, #7b2ff7);
    border: none; color: #0b0f19; font-weight: 600;
    padding: 10px 26px; border-radius: 30px; margin: 6px;
  }
  .btn-cta:hover { opacity: .85; color: #0b0f19; }

  footer.app-footer {
    text-align: center;
    padding: 30px;
    color: #6b7280;
    border-top: 1px solid rgba(255,255,255,.06);
    margin-top: 40px;
  }

  .cert-img { max-width: 100%; border-radius: 10px; border: 1px solid rgba(255,255,255,.08); }
"

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Base de Conteúdo (PREENCHER AOS POUCOS)----

## Marca da Navbar (independente do resto do site)----
# Alterar este nome NAO afeta a capa, perfil ou rodape (que usam perfil$nome)
brand_navbar <- "Michel Lima"

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
  # , list(id = "exp2", empresa = "...", ...)   <- adicione o próximo aqui
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
  # , list(id = "proj2", titulo = "...", ...)   <- adicione o próximo aqui
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
    pdf           = "certificados/cert1.pdf"   # caminho relativo a /www
  )
  # , list(id = "cert2", titulo = "...", ...)   <- adicione o próximo aqui
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
    scale_fill_gradient(low = "#7b2ff7", high = "#00f5d4") +
    theme_minimal(base_size = 13) +
    theme(
      legend.position   = "none",
      plot.background   = element_rect(fill = "transparent", color = NA),
      panel.background  = element_rect(fill = "transparent", color = NA),
      text              = element_text(color = "#c9d1d9"),
      axis.text         = element_text(color = "#c9d1d9"),
      panel.grid.major  = element_line(color = "rgba(255,255,255,.06)"),
      panel.grid.minor  = element_blank()
    ) +
    labs(x = NULL, y = NULL, title = titulo)
  
  ggplotly(p) %>%
    layout(
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor  = "rgba(0,0,0,0)",
      font          = list(color = "#c9d1d9")
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

## Hub de Experiências----
pagina_experiencias_home <- function() {
  div(
    style = "padding: 30px;",
    h2("Experiência Profissional", class = "accent-text"),
    p("Um resumo de toda a minha trajetória. Clique em um item para ver os detalhes completos."),
    tags$hr(),
    fluidRow(
      lapply(experiencias, function(exp) {
        column(width = 4, gerar_card_hub(exp$id, exp$empresa, paste0(exp$cargo, " • ", exp$periodo)))
      })
    )
  )
}

## Hub de Projetos----
pagina_projetos_home <- function() {
  div(
    style = "padding: 30px;",
    h2("Meus Projetos", class = "accent-text"),
    p("Uma seleção dos projetos que desenvolvi. Clique em um item para ver os detalhes completos."),
    tags$hr(),
    fluidRow(
      lapply(projetos, function(proj) {
        column(width = 4, gerar_card_hub(proj$id, proj$titulo, proj$subtitulo))
      })
    )
  )
}

## Hub de Certificados----
pagina_certificados_home <- function() {
  div(
    style = "padding: 30px;",
    h2("Certificados", class = "accent-text"),
    p("Cursos e certificações concluídos. Clique em um item para ver os detalhes completos."),
    tags$hr(),
    fluidRow(
      lapply(certificados, function(cert) {
        column(width = 4, gerar_card_hub(cert$id, cert$titulo, paste0(cert$instituicao, " • ", cert$ano)))
      })
    )
  )
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Páginas Fixas (Início, Perfil, Habilidades, Contato)----

## Início (Capa)----
pagina_inicio <- function() {
  tagList(
    div(
      class = "hero",
      tags$img(src = perfil$foto),
      h1(HTML(paste0("Olá, eu sou <span class='accent-text'>", perfil$nome, "</span>"))),
      p(class = "subtitle", perfil$cargo),
      p(perfil$tagline),
      actionButton("btn_ver_projetos", "Ver Projetos", class = "btn-cta", icon = icon("diagram-project")),
      downloadButton("btn_download_cv", "Baixar CV", class = "btn-cta"),
      actionButton("btn_ir_contato", "Fale comigo", class = "btn-cta", icon = icon("paper-plane"))
    ),
    fluidRow(
      style = "max-width: 900px; margin: 30px auto;",
      column(4, div(class = "stat-box", div(class = "num", length(experiencias)), div(class = "lab", "Experiências"))),
      column(4, div(class = "stat-box", div(class = "num", length(projetos)), div(class = "lab", "Projetos"))),
      column(4, div(class = "stat-box", div(class = "num", length(certificados)), div(class = "lab", "Certificados")))
    )
  )
}

## Perfil----
pagina_perfil <- function() {
  fluidRow(
    style = "padding: 30px;",
    column(
      width = 4,
      div(
        class = "content-card", style = "text-align:center;",
        tags$img(src = perfil$foto, style = "width:160px;height:160px;border-radius:50%;object-fit:cover;border:3px solid #00f5d4;"),
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

## Habilidades----
pagina_habilidades <- function() {
  fluidRow(
    style = "padding: 30px;",
    column(
      width = 6,
      div(class = "content-card", h3("Radar de Competências", class = "accent-text"),
          plotlyOutput("radar_habilidades", height = "420px"))
    ),
    column(
      width = 6,
      div(class = "content-card", h3("Ferramentas & Linguagens", class = "accent-text"),
          badge_tech(habilidades_tecnicas$habilidade))
    )
  )
}

## Contato----
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

# UI----
ui <- navbarPage(
  title       = div(icon("chart-line"), " ", brand_navbar),
  id          = "navbar_principal",
  theme       = tema_app,
  collapsible = TRUE,
  position    = "fixed-top",
  header      = tags$head(tags$style(HTML(css_custom))),
  
  tabPanel("Início", value = "inicio", icon = icon("house"), pagina_inicio()),
  tabPanel("Perfil", value = "perfil", icon = icon("user"), pagina_perfil()),
  
  do.call(navbarMenu, c(
    list(title = "Experiência", icon = icon("briefcase")),
    list(tabPanel("Todas as Experiências", value = "experiencias_home", icon = icon("list"), pagina_experiencias_home())),
    list("----"),
    lapply(experiencias, gerar_pagina_experiencia)
  )),
  
  do.call(navbarMenu, c(
    list(title = "Projetos", icon = icon("diagram-project")),
    list(tabPanel("Todos os Projetos", value = "projetos_home", icon = icon("list"), pagina_projetos_home())),
    list("----"),
    lapply(projetos, gerar_pagina_projeto)
  )),
  
  do.call(navbarMenu, c(
    list(title = "Certificados", icon = icon("certificate")),
    list(tabPanel("Todos os Certificados", value = "certificados_home", icon = icon("list"), pagina_certificados_home())),
    list("----"),
    lapply(certificados, gerar_pagina_certificado)
  )),
  
  tabPanel("Habilidades", value = "habilidades", icon = icon("chart-simple"), pagina_habilidades()),
  tabPanel("Contato", value = "contato", icon = icon("envelope"), pagina_contato()),
  
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
    updateQueryString(
      paste0("?aba=", input$navbar_principal),
      mode = "push"
    )
  }, ignoreInit = TRUE)
  
  ## Navegação a partir dos cards das páginas "Ver todos"----
  lapply(c(experiencias, projetos, certificados), function(item) {
    local({
      item_id <- item$id
      observeEvent(input[[paste0("goto_", item_id)]], {
        updateNavbarPage(session, "navbar_principal", selected = item_id)
      }, ignoreInit = TRUE)
    })
  })
  
  ## Gráficos de Experiências----
  lapply(experiencias, function(exp) {
    local({
      exp_local <- exp
      output[[paste0("plot_", exp_local$id)]] <- renderPlotly({
        grafico_barras(exp_local$grafico, "")
      })
    })
  })
  
  ## Gráficos de Projetos----
  lapply(projetos, function(proj) {
    local({
      proj_local <- proj
      output[[paste0("plot_", proj_local$id)]] <- renderPlotly({
        grafico_barras(proj_local$grafico, "")
      })
    })
  })
  
  ## Downloads de Certificados (PDF original)----
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
      line = list(color = "#00f5d4"), fillcolor = "rgba(0,245,212,.25)"
    ) %>%
      layout(
        polar = list(
          radialaxis = list(visible = TRUE, range = c(0, 100), color = "#c9d1d9"),
          bgcolor = "rgba(0,0,0,0)"
        ),
        paper_bgcolor = "rgba(0,0,0,0)",
        font = list(color = "#c9d1d9"),
        showlegend = FALSE
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
  
  ## Formulário de contato (placeholder - integrar com envio de e-mail futuramente)----
  observeEvent(input$btn_enviar_contato, {
    showNotification("Mensagem registrada! (integrar envio real de e-mail futuramente)", type = "message")
  })
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Executar Aplicação----
shinyApp(ui, server)