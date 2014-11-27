##
#The MIT License (MIT)
#
# Copyright (c) 2013 Jerome Quere <contact@jeromequere.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
##

app = angular.module('app', ['ngRoute', 'ui.bootstrap', 'ngProgress']);

loader = ['config', 'city', '$route', (config, city, $route) ->
	config.load().then () ->
		params = $route.current.params
		if params.country && params.city
			city.changeCity("#{params.country}/#{params.city}")
]

resolver = {Loader: loader}

app.config ['$locationProvider', '$routeProvider', ($locationProvider, $routeProvider) ->
	$routeProvider.when('/:country/:city/conferences', {controller: ConferencesPageController, templateUrl: "templates/conferences.tpl.html", resolve: resolver});
	$routeProvider.when('/:country/:city/netsoul', {controller: NetsoulPageController, templateUrl: "templates/netsoul.tpl.html", resolve: resolver});
	$routeProvider.when('/:country/:city/susies', {controller: SusiesPageController, templateUrl: "templates/susies.tpl.html", resolve: resolver});
	$routeProvider.when('/:country/:city/roadblocks', {controller: RoadBlocksPageController, templateUrl: "templates/roadBlocks.tpl.html", resolve: resolver});
	$routeProvider.when('/:country/:city/projects', {controller: ProjectsPageController, templateUrl: "templates/projects.tpl.html", resolve: resolver});
	$routeProvider.when('/error', {templateUrl: "templates/error.tpl.html"});
	$routeProvider.when('/:country/:city/?', {controller: HomePageController , templateUrl: "templates/home.tpl.html", resolve: resolver});
	$routeProvider.when('/', {controller: HomePageController, templateUrl: "templates/home.tpl.html"});
	$routeProvider.otherwise({templateUrl: "templates/error.tpl.html"});
	$locationProvider.html5Mode(true);
]

app.service 'config', ConfigServiceController
app.service 'city', CityServiceController
app.service 'wsEpitech', WsEpitechServiceController;

app.controller 'HeaderController', HeaderController
app.directive 'halloffame', () -> {scope: {login: '=', picture: '=', offset: '=', total: '=', icon: '='}, templateUrl: 'templates/hallOfFame.tpl.html'}
app.directive 'project', () -> {scope: {project: '='}, controller: ProjectDirectiveController, replace: true, templateUrl: 'templates/projectDirective.tpl.html', restrict: 'E'}

app.filter 'hallOfFameTime', () -> (total) ->
	hours = Math.floor(total / 3600)
	mins = Math.floor(total / 60) - hours * 60
	secs = Math.floor(total % 60)
	return "#{hours}h #{mins}m #{secs}s"

app.filter 'padding', () -> (nb) ->
	nb = parseInt(nb)
	if (nb < 10) then return "0#{nb}"
	return nb;

app.run ($rootScope, $location) ->
	$rootScope.$on '$routeChangeError', (e) -> $location.url('/error');
