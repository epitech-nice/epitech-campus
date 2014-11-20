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

app.config ['$locationProvider', '$routeProvider', ($locationProvider, $routeProvider) ->
	$routeProvider.when('/:cityCode*/netsoul', {controller:"NetsoulPageController", templateUrl: "templates/netsoul.tpl.html"});
	$routeProvider.when('/:cityCode*/susies', {controller: SusiesPageController, templateUrl: "templates/susies.tpl.html"});
	$routeProvider.when('/:cityCode*/roadblocks', {controller: RoadBlocksPageController, templateUrl: "templates/roadBlocks.tpl.html"});
	$routeProvider.when('/error', {templateUrl: "templates/error.tpl.html"});
	$routeProvider.when('/:cityCode*/?', {controller:"HomePageController", templateUrl: "templates/home.tpl.html"});
	$routeProvider.when('/', {controller:"HomePageController", templateUrl: "templates/home.tpl.html"});
	$locationProvider.html5Mode(true);
]

app.service 'config', ConfigServiceController
app.service 'city', CityServiceController
app.factory 'wsEpitech', ['$injector', ($injector) -> $injector.instantiate(WsEpitechServiceController, {'wsUrl':'http://archlinux:4343'}) ];
app.controller 'HeaderController', HeaderController

app.controller 'HomePageController', HomePageController
app.controller 'NetsoulPageController', NetsoulPageController
app.controller 'RoadBlocksPageController', RoadBlocksPageController


app.directive 'halloffame', () -> {scope: {login: '=', picture: '=', offset: '=', total: '=', icon: '='}, templateUrl: 'templates/hallOfFame.tpl.html'}
app.filter 'hallOfFameTime', () -> (total) ->
	hours = Math.floor(total / 3600)
	mins = Math.floor(total / 60) - hours * 60
	secs = Math.floor(total % 60)
	return "#{hours}h #{mins}m #{secs}s"
