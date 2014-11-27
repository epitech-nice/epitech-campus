class ProjectDirectiveController
	@$inject = ['$scope', '$timeout']
	constructor: (@$scope, @$timeout) ->
		@$scope.isFinished = @isFinished;
		@$scope.isStarted = @isStarted;
		@project = @$scope.project;
		@onTimeout();

	onTimeout: () =>
		@$timeout(@onTimeout, 500);
		if (!@isStarted())
			@$scope.countdown = @initCountDown(@$scope.project.start);
		else if (!@isFinished())
			@$scope.countdown = @initCountDown(@$scope.project.end);

	isFinished: () => moment().isAfter(moment(@project.end))
	isStarted: () => moment().isAfter(moment(@project.start))

	initCountDown: (date) ->
		s = moment(date).diff(moment(), 'seconds');
		countdown = {}
		countdown.days = Math.floor(s / (3600 * 24))
		s -= countdown.days * 3600 * 24;
		countdown.hours = Math.floor(s / 3600)
		s -= countdown.hours * 3600;
		countdown.minutes = Math.floor(s / 60)
		countdown.seconds = s % 60
		return countdown;
