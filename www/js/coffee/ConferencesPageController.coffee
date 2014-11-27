class ConferencesPageController

	@$inject = ['$scope', 'city', 'wsEpitech', 'ngProgress']

	constructor: (@$scope, @cityService, @wsEpitech, @ngProgress) ->
		@$scope.filters = {};
		@$scope.filters.promo = false;
		@$scope.filters.login = '';
		@$scope.user = [];
		@$scope.promo = [];
		@$scope.applyFilters = @applyFilters;
		@users = []
		@ngProgress.start();
		p = @cityService.getUsers().then (users) =>
			@users = @buildUsers(users);
			@$scope.promos = @buildPromo(@users);
			@getConferanceModule().then (module) =>
				@wsEpitech.getModulePresent(module.scholaryear, module.moduleCode, module.instanceCode).then (data) =>
					for login, user of @users
						user.registered = data[login]?;
						user.nbPresent = if (data[login]?) then data[login].total_present else 0;
						user.nbAbsent = if (data[login]?) then data[login].total_absent else 0;
					@applyFilters();
					@ngProgress.complete();
		p.catch () => @ngProgress.stop();

	buildUsers: (users) ->
		users = _.filter(users, (u) -> u.promo != "ADM")
		_.object(_.pluck(users, 'login'), users)
	buildPromo: (user) -> _.chain(user).pluck('promo').uniq().sort().reverse().value();

	getConferanceModule: () ->
		@wsEpitech.getCityModules(@cityService.getCode()).then (modules) ->
			m = _.chain(modules).filter((m) -> m.moduleCode == "G-EPI-007").sortBy((m) -> -m.scholaryear).first().value();

	applyFilters: () =>
		@$scope.users = _.filter @users, (user) =>
			exp = new RegExp(@$scope.filters.login);
			return (!@$scope.filters.login || exp.test(user.login)) && (!@$scope.filters.promo || @$scope.filters.promo == "#{user.promo}")
