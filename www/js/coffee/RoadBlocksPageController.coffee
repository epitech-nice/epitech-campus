class RoadBlocksPageController

	@$inject = ['$scope', '$q', 'ngProgress', 'city', 'wsEpitech']

	@ROADBLOCKS = [
		{code: 'B-ANG-084', name: 'TOEIC 550'},
		{code: 'B-CUI-050-1', name: 'CUI'},
		{code: 'B-ANG-284-1', name: 'TOEIC 650'},
		{code: 'B-CPE-330', name: 'Exams C'},
		{code: 'B-ANG-484-1', name: 'TOEIC 750'},
		{code: 'B-NET-460-1', name: 'Network'},
		{code: 'G-EPI-007', name: 'Conferences'},
		{code: 'B-BDD-350', name: 'SQL'}
	]
	@FRENCH_ROADBLOCKS = ['B-PRO-050', 'B-PRO-125', 'B-PRO-360', 'B-PRO-460', 'B-PRO-540'];
	constructor: (@$scope, @$q, ngProgress, @cityService, @wsEpitech) ->
		@users = {};
		@$scope.promo = [];
		@$scope.users = [];
		@$scope.filters = {login: '', promo: ''}
		@$scope.applyFilters = @applyFilters;
		@$scope.roadBlocks = @constructor.ROADBLOCKS;

		ngProgress.start();
		p = @cityService.getUsers().then (users) =>
			@users = @buildUsers(users);
			@$scope.promos = @buildPromo(@users);
			@cityService.getModules().then (modules) =>
				@loadGrades(modules).then () =>
					@applyFilters();
					ngProgress.complete();
		p.catch () => ngProgress.stop();

	buildUsers: (users) ->
		users = _.filter(users, (u) -> u.promo != "ADM")
		tab = _.chain(users).pluck('login').object(users).value()
		_.each tab, (user) -> user.barrages = {}
		return tab;
	buildPromo: (user) -> _.chain(user).pluck('promo').uniq().sort().reverse().value();

	loadGrades: (modules) ->
		grades = {}
		b = _.chain(@constructor.ROADBLOCKS).pluck("code").union(@constructor.FRENCH_ROADBLOCKS).value();
		modules = _.filter modules, (m) => _.indexOf(b, m.moduleCode) != -1
		promises = []
		for module in modules
			do (module) =>
				promises.push @wsEpitech.getModuleRegistered(module.scholaryear, module.moduleCode, module.instanceCode).then (registered) =>
					for login, data of registered
						if (data.grade != '-' && data.grade != 'Echec' && @users[login]?)
							@users[login].barrages[module.moduleCode] = true;
		return @$q.all(promises).then () =>
			for login, user of @users
				c = 0
				for code in @constructor.FRENCH_ROADBLOCKS
					c += if(user.barrages[code]) then 1 else 0
				user.barrages.french = c

	applyFilters: () =>
		@$scope.users = _.filter @users, (user) =>
			exp = new RegExp(@$scope.filters.login);
			return (!@$scope.filters.login || exp.test(user.login)) && (!@$scope.filters.promo || @$scope.filters.promo == "#{user.promo}")
