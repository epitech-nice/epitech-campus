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
