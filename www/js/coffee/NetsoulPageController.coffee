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

class NetsoulPageController

	@$inject = ['$scope', 'city', 'wsEpitech', 'ngProgress', '$q']
	constructor: (@$scope, @cityService, @wsEpitech, @ngProgress, $q) ->
		@users = {}
		@netsoul = {}
		@$scope.netsoul = [];
		@$scope.filters = {promos: {}, states: {'At School': true, 'Elswhere': false, 'Not Connected': false}}

		@$scope.$watch('filters', @applyFilters, true);

		@ngProgress.start();
		p = @cityService.getUsers().then (users) =>
			@users = @buildUsers(users);
			@$scope.filters.promos = @buildPromos(users);
			$q.all([@refreshNetsoul(), @refreshHallOfFame()]).then () => @ngProgress.complete();
		p.catch () => @ngProgress.stop()

	buildUsers: (users) ->	_.object(_.pluck(users, 'login'), users)
	buildPromos: (users) -> _.object(_.uniq(_.pluck(users, 'promo')), []);

	refreshNetsoul: () ->
		@wsEpitech.getCityNetsoul(@cityService.getCode()).then (data) =>
			@netsoul = {};
			for login, state of data
				@netsoul[login] = _.extend(state, @users[login])
				@netsoul[login].color = @getColor(@netsoul[login]);
			@applyFilters();

	applyFilters: () =>
		filters = [];
		filters.push (user) =>
			if _.every(@$scope.filters.states,  (t) -> !t) then return true;
			bool = false
			if (@$scope.filters.states['At School'])
				bool = bool || user.isAtEpitech
			if (@$scope.filters.states['Elswhere'])
				bool = bool || user.connected
			if (@$scope.filters.states['Not Connected'])
				bool = bool || !user.connected
			return bool
		filters.push (user) =>
			return _.every(@$scope.filters.promos, (t) -> !t) || _.some @$scope.filters.promos, (b, promo) ->
				return "#{user.promo}" == promo && b
		@$scope.netsoul = _.filter @netsoul, (user) ->
			bool = true;
			for filter in filters
				bool = bool && filter(user)
			return bool

	getColor: (state) ->
		if state.isAtEpitech
			if state.isActif then return "#67E300"
			return "#C1FF8D"
		if state.connected
			if state.isActif then return "#FF0700"
			return "#FF7673"
		return "#fff";

	refreshHallOfFame: () ->
		start = moment().subtract(8, 'days').format('YYYY-MM-DD');
		end = moment().format('YYYY-MM-DD');
		@wsEpitech.getCityNsLog(@cityService.getCode(), start, end).then (data) =>
			@$scope.hallOfFame = _.chain(data)
			.map((netsoul, login) =>
				netsoul.login = login
				netsoul.total = netsoul.idleSchool + netsoul.school
				return _.extend(netsoul, @users[login]);
			).sortBy((d) -> -(d.total))
			.first(10)
			.value();
