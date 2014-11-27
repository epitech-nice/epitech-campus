class HeaderController

	@$inject = ['$scope', 'city', '$location', '$rootScope'];

	constructor: (@$scope, @cityService, @$location, @$rootScope) ->
		@cityService.onCityChange(@onCityChanged);
		@$scope.onCitySelect = @onCitySelect;
		@onCityChanged();
		@$scope.menu = {'netsoul': 'Netsoul', 'projects': 'Projects'};
		@$scope.menuModule = {'susies': 'Susies', 'conferences': 'Conferences', 'roadblocks': 'Road-Blocks'};
		@$scope.page = @getCurrentPage();
		@$rootScope.$on('$routeChangeSuccess', @onPageChange);

	onPageChange: () =>
		@$scope.page = @getCurrentPage();

	onCityChanged: () =>
		@$scope.cityCode = @cityService.getCode();
		if (@$scope.cityCode == null)
			@$scope.cityCode = "";

	getCurrentPage: () ->
		tab = @$location.url().split('/');
		if (tab.length == 3) then return ''
		return tab.pop();

	onCitySelect: (cityCode) =>
		@$location.url("#{cityCode}/#{@getCurrentPage()}");
