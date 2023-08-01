---
title: Packages
permalink: /packages/
menu_item: false
layout: default
---

# Packages

<ul class="row projects projects-container">
	{% assign sorted_lectures = site.projects | where: 'type', 'code' %}
	<div class="row">
		{% for lecture in sorted_lectures reversed %}
		<li class="col-lg-4 projects-item filter-{{ lecture.type }}">
			<a target="_blank" href="{{ lecture.link }}">
			  <div class="project d-flex flex-column align-items-start">
				<div class="item-info d-flex">
				  <div class="item-pic"><img src="/assets/img/projects/{{ lecture.image }}"></div>
				  <div class="item-title">
					<h3 class="name">{{ lecture.name }}</h3>
					<p class="type type-{{ lecture.type }}"><span>{{ lecture.type }}</span></p>
				  </div>
				</div>
				<div class="item-desc">
				  {{ lecture.description | markdownify }}
				</div>
			  </div>
			</a>
		  </li>
		{% endfor %}
	</div>
</ul>