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

class RoadBlocksPageController

	@$inject = ['$scope', '$q', 'ngProgress', 'city', 'epitechWs']

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
	constructor: (@$scope, @$q, ngProgress, @cityService, @epitechWs) ->
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
				promises.push @epitechWs.getModuleRegistered(module.scholaryear, module.moduleCode, module.instanceCode).then (registered) =>
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
