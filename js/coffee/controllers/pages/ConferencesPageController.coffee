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

class ConferencesPageController

	@$inject = ['$scope', 'city', 'epitechWs', 'ngProgress']

	constructor: (@$scope, @cityService, @epitechWs, @ngProgress) ->
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
				@epitechWs.getModulePresent(module.scholaryear, module.moduleCode, module.instanceCode).then (data) =>
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
		@epitechWs.getCityModules(@cityService.getCode()).then (modules) ->
			m = _.chain(modules).filter((m) -> m.moduleCode == "G-EPI-007").sortBy((m) -> -m.scholaryear).first().value();

	applyFilters: () =>
		@$scope.users = _.filter @users, (user) =>
			exp = new RegExp(@$scope.filters.login);
			return (!@$scope.filters.login || exp.test(user.login)) && (!@$scope.filters.promo || @$scope.filters.promo == "#{user.promo}")
