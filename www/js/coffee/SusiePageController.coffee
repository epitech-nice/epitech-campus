class SusiesPageController

	@$inject = ['$scope', '$routeParams', '$location', 'config', 'city', 'wsEpitech', 'ngProgress']
	constructor: (@$scope, $routeParams, $location, @config, @cityService, @wsEpitech, @ngProgress) ->
		@toDo = {}
		@$scope.toDo = @toDo;
		@$scope.filters = {};
		@$scope.filters.promo = false;
		@$scope.filters.login = '';
		@$scope.user = [];
		@$scope.promo = [];
		@$scope.applyFilters = @applyFilters;
		@users = []
		@ngProgress.start();
		p = @cityService.changeCity($routeParams.cityCode).then () =>
			@toDo = @$scope.toDo = @config.getSusieToDo(@cityService.getCode())
			@cityService.getUsers().then (users) =>
				@users = @buildUsers(users);
				@$scope.promos = @buildPromo(users);
				@wsEpitech.getCalendarPresent(@config.getSusieCalendarId(@cityService.getCode())).then (data) =>
					for login, user of @users
						user.nbSusies = if (data[login]?) then data[login].total_present else 0;
						toDo = if (@toDo[user.promo]?) then @toDo[user.promo] else 0;
						user.toDo = Math.max(0, toDo - user.nbSusies);
					@applyFilters();
					@ngProgress.complete();

		p.catch () =>
			@ngProgress.stop();
			$location.url('/error');

	buildUsers: (users) ->	_.object(_.pluck(users, 'login'), users)
	buildPromo: (user) -> _.chain(user).pluck('promo').uniq().sort().reverse().value();

	applyFilters: () =>
		@$scope.users = _.filter @users, (user) =>
			exp = new RegExp(@$scope.filters.login);
			return (!@$scope.filters.login || exp.test(user.login)) && (!@$scope.filters.promo || @$scope.filters.promo == "#{user.promo}")
