class ProjectsPageController
	@$inject = ['$scope', 'city', 'ngProgress']

	constructor: (@$scope, @cityService, ngProgress) ->
		@projects = []
		@$scope.projects = [];
		@$scope.filters = {}
		@$scope.filters.states = {"Not Started": false, "Running": true, "Finished": false}
		@$scope.filters.promos = {"Tek1": false, "Tek2":false, "Tek3": false}
		@$scope.applyFilters = @applyFilters;
		ngProgress.start();
		@cityService.getProjects().then (@projects) =>
			@projects = _.filter @projects, (p) -> p.start? && p.end?
			@projects = _.sortBy @projects, (p) =>
				if !@isStarted(p) then return p.start;
				return p.end
			@applyFilters();
			ngProgress.complete();


	isStarted: (project) -> moment().isAfter(moment(project.start))
	isFinished: (project) => moment().isAfter(moment(project.end))

	applyFilters: () =>
		filters = [];
		filters.push (project) =>
			if _.every(@$scope.filters.states,  (t) -> !t) then return true;
			bool = false
			if (@$scope.filters.states['Not Started'])
				bool = bool || !@isStarted(project)
			if (@$scope.filters.states['Running'])
				bool = bool || (@isStarted(project) && !@isFinished(project))
			if (@$scope.filters.states['Finished'])
				bool = bool || @isFinished(project)
			return bool
		filters.push (project) =>
			if _.every(@$scope.filters.promos,  (t) -> !t) then return true;
			bool = false
			if (@$scope.filters.promos['Tek1'])
				bool = bool || project.module.semester == 1 || project.module.semester == 2
			if (@$scope.filters.promos['Tek2'])
				bool = bool || project.module.semester == 3 || project.module.semester == 4
			if (@$scope.filters.promos['Tek3'])
				bool = bool || project.module.semester == 5 || project.module.semester == 6
			return bool
		@$scope.projects = _.filter @projects, (project) ->
			bool = true;
			for filter in filters
				bool = bool && filter(project)
			return bool
