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

class CityServiceController

	@$inject = ['$rootScope', '$q', 'wsEpitech']
	@EVENT_CITY_CHANGE = 'CityServiceController::cityChanged'

	constructor: (@$rootScope, @$q, @wsEpitech) ->
		@city = null;

	getCode: () -> @city
	onCityChange: (cb) -> @$rootScope.$on(@constructor.EVENT_CITY_CHANGE, cb);

	changeCity: (cityCode) ->
		@wsEpitech.getCity(cityCode).then () =>
			oldCity = @city
			@city = cityCode;
			if (oldCity != @city) then @$rootScope.$emit(@constructor.EVENT_CITY_CHANGE);


	getUsers: () -> @wsEpitech.getCityUsers(@city);
	getNetsoul: () -> @wsEpitech.getCityNetsoul(@city);
	getModules: (year = null) -> @wsEpitech.getCityModules(@city, year);
	getProjects: () -> @getModules().then (modules) =>
		scholarYear = _.max(modules, (m) -> m.scholaryear).scholaryear;
		modules = _.filter(modules, (m) -> m.scholaryear == scholarYear)
		projects = []
		promises = []
		for m in modules
			do (m) =>
				promises.push @wsEpitech.getModuleActivities(m.scholaryear, m.moduleCode, m.instanceCode).then (activities) ->
					for act in activities
						if act.type == "proj"
							act.module = m
							projects.push act;
		@$q.all(promises).then () -> projects;
