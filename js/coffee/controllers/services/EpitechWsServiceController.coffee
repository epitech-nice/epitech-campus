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

class EpitechWsServiceController
	@$inject = ['$http', 'config']

	constructor: (@$http, @config) ->

	getCities: () -> @_get("cities");
	getCityUsers: (cityCode) -> @_get("#{cityCode}/users");
	getCityNetsoul: (cityCode) -> @_get("#{cityCode}/netsoul");
	getCityNsLog: (cityCode, start, end) -> @_get("#{cityCode}/nslog?start=#{start}&end=#{end}")
	getCityModules: (cityCode, year = null) ->
		url = "#{cityCode}/modules"
		if (year) then url = "#{url}?year=#{year}";
		@_get(url)

	getModuleRegistered: (year, moduleCode, instanceCode) -> @_get("module/#{year}/#{moduleCode}/#{instanceCode}/registered")
	getModulePresent: (year, moduleCode, instanceCode) -> @_get("module/#{year}/#{moduleCode}/#{instanceCode}/present")
	getModuleActivities: (year, moduleCode, instanceCode) -> @_get("module/#{year}/#{moduleCode}/#{instanceCode}/activities")

	getCalendarPresent: (calendarId) -> @_get("calendar/#{calendarId}/present")

	_get: (path) ->
		wsUrl = @config.getWsUrl()
		return @$http.get("#{wsUrl}/#{path}").then (httpRes) ->
			data = httpRes.data;
			if (data.code != 200) then throw data.msg;
			return data.data;
