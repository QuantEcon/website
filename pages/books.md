---
title: Books
permalink: /books/
menu_item: false
layout: default
---

# Books

<div class="home-series">
    <ul>
        {% assign sorted_projects = site.projects | where: 'type', 'book' %}
        {% for project in sorted_projects reversed %}
        <li>
            <a href="{{ project.link }}">
                <span class="icon_book"><img src="/assets/img/{{ project.image }}"></span>
                <h3 color="#3070B6">{{ project.name }}</h3>
				<p>{{ project.description }}</p>
            </a>
        </li>
		{% endfor %}
    </ul>
</div>

<!-- <div class="container">
<div class="col-md-6">
<div class="row">
<div class="home-series">
    {% assign sorted_projects = site.projects | where: 'type', 'book' %}
    <div class="row">
    {% for project in sorted_projects reversed %}
        <a href="{{ project.link }}">
                <span class="icon"><img src="/assets/img/{{ project.image }}"></span>
            <div class="col-md-4 offset-md-0 d-none d-md-block">
            <img src="/assets/img/{{ project.image }}" class="img-thumbnail" alt="Screenshot showing a lecture page">
            </div>
            <h3 color="#3070B6">{{ project.name }}</h3>
			<p>{{ project.description }}</p>
        </a>
    {% endfor %}
    </div>
</div>
</div>
</div>    
</div> -->

<!-- <div class="col-md-6">
<div class="row">
    <div class="col-md-4 offset-md-0 d-none d-md-block">
        <p><img src="/assets/img/dp-image.png" class="img-thumbnail" alt="Screenshot showing a lecture page"></p>
    </div>
    <div class="col-md-8 offset-md-0">
        <h3>Dynamic Programming</h3>
        <p>This book is about dynamic programming and its applications in economics, finance, and adjacent
                fields like operations research. It brings together recent innovations in the theory of dynamic
                programming.</p>
        <p><a href="https://dp.quantecon.org/" class="btn-learn-more">View online version</a></p>
    </div>
</div>    
</div> -->


<!-- <div class="row">
        {% assign sorted_projects = site.projects | where: 'type', 'book' %}
        {% for project in sorted_projects reversed %}
		<div class="col-lg-6 team-item">
			<div class="member d-flex align-items-start">
				<div class="pic"><img src="/assets/img/{{ project.image }}" class="img-fluid" alt=""></div>
				<div class="member-info">
					<h3><a href="{{ project.link }}">{{ project.name }}</a></h3>
					<p>{{ project.description }}</p>
				</div>
			</div>
		</div>
		{% endfor %}
	</div> -->

<!-- <div class="row justisfy-content-center gx-5" data-aos="zoom-in" data-aos-delay="300">
<div class="col-md-6">
<div class="row">
<div class="col-md-4 offset-md-0 d-none d-md-block">
    {% assign sorted_projects = site.projects | where: 'type', 'book' %}
    {% for project in sorted_projects reversed %}
	<div class="col-lg-6 team-item">
		<li>
            <a href="{{ project.link }}">
                <span class="icon"><img src="/assets/img/{{ project.image }}"></span>
                <h3 color="#3070B6">{{ project.name }}</h3>
				<p>{{ project.description }}</p>
            </a>
        </li>		
        </div>
	</div>
	{% endfor %}
</div>
</div> -->
