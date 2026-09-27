<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>bits.alexalemi.com</title>
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-F5SW43T5NT"></script>
    <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());

    gtag('config', 'G-F5SW43T5NT');
    </script>

		<!-- favicon stuff -->
		<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
		<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
		<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
		<link rel="manifest" href="/site.webmanifest">
		<meta name="msapplication-TileColor" content="#da532c">
		<meta name="theme-color" content="#fefefe" media="(prefers-color-scheme: light)">
		<meta name="theme-color" content="#16171F" media="(prefers-color-scheme: dark)">

    <!-- RSS Feed -->
    <link rel="alternate" type="application/rss+xml" title="bits.AlexAlemi.com" href="https://bits.alexalemi.com/bits.xml" />

    <!-- Search Engine -->
    <meta name="description" content="Alex Alemi's Bits - Short thoughts, links, and finds">
    <link rel="canonical" href="https://bits.alexalemi.com/">

    <!-- Open Graph (Facebook, LinkedIn, Slack, Bluesky, ...) -->
    <meta property="og:type" content="website">
    <meta property="og:title" content="Alex Alemi's Bits">
    <meta property="og:description" content="Alex Alemi's Bits - Short thoughts, links, and finds">
    <meta property="og:url" content="https://bits.alexalemi.com/">
    <meta property="og:site_name" content="bits.alexalemi.com">
    <meta property="og:image" content="https://alexalemi.com/assets/images/me_small.jpg">
    <meta property="og:image:alt" content="Headshot of Alex Alemi">

    <!-- Twitter / X (falls back to og:* for title, description, image) -->
    <meta name="twitter:card" content="summary">
    <meta name="twitter:creator" content="@alemi">

    <!-- Structured data -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "Blog",
      "name": "Alex Alemi's Bits",
      "description": "Short thoughts, links, and finds",
      "url": "https://bits.alexalemi.com/",
      "author": { "@type": "Person", "name": "Alexander A. Alemi", "url": "https://alexalemi.com/" }
    }
    </script>

    <!-- Prerender same-origin links on hover -->
    <script type="speculationrules">
    { "prerender": [{ "where": { "href_matches": "/*" }, "eagerness": "moderate" }] }
    </script>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,400;0,700;1,400&family=Mulish:wght@700&display=swap">

    <!-- Inline CSS -->
    <link rel="stylesheet" type="text/css" href="assets/style.css"/>
    <style>
      .bit {
        margin-bottom: 1.5em;
        padding-bottom: 1em;
        border-bottom: 1px solid var(--rule-color);
      }
      .bit:last-child {
        border-bottom: none;
      }
      .bit-meta {
        font-size: 0.85em;
        color: var(--alt-color);
        margin-top: 0.5em;
      }
      .bit-meta a {
        color: var(--alt-color);
      }
      .bit-content {
        margin: 0.5em 0;
      }
      .bit-link {
        font-weight: bold;
      }
      .bit-tags {
        font-size: 0.8em;
      }
      .bit-tags span {
        background: var(--chip-color);
        padding: 0.1em 0.4em;
        border-radius: 3px;
        margin-right: 0.3em;
      }
      .bit-via {
        font-style: italic;
      }
    </style>

</head>

<body>

    <!-- Header with social links -->
    <header>
        <h1 style="margin-top: 0px; margin-bottom: 4px">Alex Alemi's Bits</h1>
        <nav aria-label="Site">
          <a href="https://bits.alexalemi.com" aria-current="page">Bits</a> |
          <a href="https://blog.alexalemi.com">Blog</a> |
          <a href="https://alexalemi.com">About Me</a> |
          <a rel="alternate" type="application/rss+xml" title="bits.AlexAlemi.com" href="https://bits.alexalemi.com/bits.xml">RSS</a>
        </nav>
    </header>

    <main>
      <!-- Bio and stuff -->
      <p>Short thoughts, interesting links, and things I've found.</p>

    <!--- Bits stream --->
    <div class="listing">
      {% for bit in bits %}
        <article class="bit">
          {% if bit.url %}
            <a class="bit-link" href="{{ bit.url }}" target="_blank" rel="noopener">{{ bit.title }}</a>
          {% else %}
            <span class="bit-link">{{ bit.title }}</span>
          {% endif %}

          {% if bit.content %}
            <p class="bit-content">{{ bit.content }}</p>
          {% endif %}

          <div class="bit-meta">
            <time datetime="{{ bit.date }}">{{ bit.date }}</time>
            {% if bit.via %}
              <span class="bit-via">via {{ bit.via }}</span>
            {% endif %}
            {% if bit.tags %}
              <span class="bit-tags">
                {% for tag in bit.tags %}
                  <span>{{ tag }}</span>
                {% endfor %}
              </span>
            {% endif %}
          </div>
        </article>
      {% endfor %}
    </div>
    </main>

		<footer>
		<p>
		DISCLAIMER: This is a personal website, produced in my own time and solely reflecting my
		personal opinions. Statements on this site do not represent the views or policies of my
		employer.
		</p>
		</footer>


</body>
</html>
