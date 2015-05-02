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
	$routeProvider.when('/:country/:city/conferences', {
		controller: ConferencesPageController,
		templateUrl: "templates/pages/conferences/index.tpl",
		resolve: resolver
	});
	$routeProvider.when('/:country/:city/netsoul', {
		controller: NetsoulPageController,
		templateUrl: "templates/pages/netsoul/index.tpl",
		resolve: resolver
	});
	$routeProvider.when('/:country/:city/susies', {
		controller: SusiesPageController,
		templateUrl: "templates/pages/susies/index.tpl",
		resolve: resolver
	});
	$routeProvider.when('/:country/:city/roadblocks', {
		controller: RoadBlocksPageController,
		templateUrl: "templates/pages/roadBlocks/index.tpl",
		resolve: resolver
	});
	$routeProvider.when('/:country/:city/projects', {
		controller: ProjectsPageController,
		templateUrl: "templates/pages/projects/index.tpl",
		resolve: resolver
	});
	$routeProvider.when('/:country/:city/error', {
		templateUrl: "templates/pages/error/index.tpl",
		resolve: resolver
	});
	$routeProvider.when('/error', {
		templateUrl: "templates/pages/error/index.tpl"
	});
	$routeProvider.when('/:country/:city/?', {
		controller: HomePageController,
		templateUrl: "templates/pages/home/index.tpl",
		resolve: resolver
	});
	$routeProvider.when('/', {
		controller: HomePageController,
		templateUrl: "templates/pages/home/index.tpl"
	});
	$routeProvider.otherwise({templateUrl: "templates/pages/error/index.tpl"});
	$locationProvider.html5Mode(true);
]

app.service('config', ConfigServiceController);
app.service('city', CityServiceController);
app.service('epitechWs', EpitechWsServiceController);

app.directive('header', HeaderDirectiveController.getConfig)
app.directive('halloffame', HallOfFameDirectiveController.getConfig);
app.directive('project', ProjectDirectiveController.getConfig);

app.filter('hallOfFameTime', HallOfFameTimeFilter.factory);
app.filter('padding', PaddingFilter.factory)

app.run(['$rootScope', '$location', 'city', ($rootScope, $location, city) ->
	$rootScope.$on('$routeChangeError', (e) ->
		console.log(city.getCode());
		if (city.getCode()?)
			$location.url("/#{city.getCode()}/error");
		else
			$location.url('/error');
	)
]);
