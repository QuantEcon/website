---
title: Packages
permalink: /packages/
menu_item: false
layout: default
---

# Code

<div class="home-series">
    <ul>
        {% assign sorted_projects = site.projects | where: 'type', 'code' %}
        {% for project in sorted_projects reversed %}
        <li>
            <a href="{{ project.link }}">
                <span class="icon"><img src="/assets/img/projects/{{ project.image }}"></span>
                <h3 color="#3070B6">{{ project.name }}</h3>
				<p>{{ project.description }}</p>
            </a>
        </li>
		{% endfor %}
    </ul>
</div>
