---
title: "QuantEcon Lectures"
permalink: /lectures111/
menu_item: true
---
# QuantEcon Lectures

<div class="home-series">
    <ul>
        {% assign sorted_lectures = site.lectures | sort: 'order' | reverse %}
        {% for lecture in sorted_lectures reversed %}
        <li>
            <a href="{{ lecture.link }}">
                <span class="icon"><img src="/assets/img/projects/{{ lecture.image }}"></span>
                <h3 color="#3070B6">{{ lecture.name }}</h3>
				<p>{{ lecture.description }}</p>
            </a>
        </li>
		{% endfor %}
    </ul>
</div>
