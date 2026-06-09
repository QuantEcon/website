---
title: Workshops and Seminars
permalink: /workshops/
menu_item: false
---
<h1>Workshops and Seminars</h1>

<p class="mb-4">QuantEcon runs remote and in-person workshops and short courses on quantitative economics and high-performance computing using Python and Julia. Past locations include the IMF, Bank of Portugal, Hitotsubashi University, Columbia University, Reserve Bank of Australia, Stanford, Princeton, Harvard, MIT, Berkeley, UCLA, and the Central Bank of Chile.</p>

<p class="mb-5">Interested in hosting a workshop? <a href="mailto:contact@quantecon.org">Contact us</a>.</p>

{% assign all_workshops = site.workshops | sort: "date" | reverse %}
{% assign recent_workshops = all_workshops | where_exp: "w", "w.year >= 2024" %}
{% assign past_workshops = all_workshops | where_exp: "w", "w.year < 2024" %}
{% assign past_years = past_workshops | map: "year" | uniq | sort | reverse %}

<h2>Recent Workshops</h2>

{% for workshop in recent_workshops %}
<div class="workshop">
    <h3 class="title">{% if workshop.date_display %}{{ workshop.date_display }}{% else %}{{ workshop.date | date: "%B %Y" }}{% endif %}, {{ workshop.location }}</h3>
    <div class="workshop-details">
        <ul>
            <li><span>Presenters:</span> {{ workshop.presenters }}</li>
            {% if workshop.repo_url %}<li><a href="{{ workshop.repo_url }}">{{ workshop.title }}</a></li>{% endif %}
        </ul>
        {% if workshop.description %}
        <div class="workshop-copy">
            <p>{{ workshop.description }}</p>
        </div>
        {% endif %}
    </div>
</div>
{% endfor %}

<br>

<h2>Past Workshops</h2>

<div class="accordion" id="pastWorkshops">
{% for year in past_years %}
  {% assign year_workshops = past_workshops | where: "year", year %}
  <div class="accordion-item">
    <h2 class="accordion-header">
      <button class="accordion-button{% unless forloop.first %} collapsed{% endunless %}" type="button" data-bs-toggle="collapse" data-bs-target="#workshops{{ year }}">
        {{ year }}
      </button>
    </h2>
    <div id="workshops{{ year }}" class="accordion-collapse collapse{% if forloop.first %} show{% endif %}" data-bs-parent="#pastWorkshops">
      <div class="accordion-body">
        {% for workshop in year_workshops %}
        <div class="workshop">
            <h3 class="title">{% if workshop.date_display %}{{ workshop.date_display }}{% else %}{{ workshop.date | date: "%B %Y" }}{% endif %}, {{ workshop.location }}</h3>
            <div class="workshop-details">
                <ul>
                    <li><span>Presenters:</span> {{ workshop.presenters }}</li>
                    {% if workshop.repo_url %}<li><a href="{{ workshop.repo_url }}">{{ workshop.title }}</a></li>{% endif %}
                </ul>
            </div>
        </div>
        {% endfor %}
      </div>
    </div>
  </div>
{% endfor %}
</div>
