class ConfigServiceController

	@$inject = ['$http']

	constructor: (@$http) ->
		@config = {}
		@promise = @load();

	load: () ->
		if (@promise?) then @promise;
		@$http.get('config.json').then (data) =>
			@config = data.data

	getWsUrl: () -> @config['ws-epitech']
	getSusieCalendarId: (cityCode) -> @config.cities[cityCode].susieCalendarId
	getSusieToDo: (cityCode) -> @config.cities[cityCode].susieToDo
