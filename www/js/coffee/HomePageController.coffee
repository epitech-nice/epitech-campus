class HomePageController

	@$inject = ['$routeParams', 'city', '$location']

	constructor: (@$routeParams, @cityService, $location) ->
		if (@$routeParams.cityCode?)
			console.log("TOTOTI");
			@cityService.changeCity(@$routeParams.cityCode).catch () ->
				console.log("TOTOT");
				$location.url('/error');
