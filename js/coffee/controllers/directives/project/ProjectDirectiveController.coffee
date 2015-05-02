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

class ProjectDirectiveController

    @getConfig: () -> {
        scope: {
            project: '='
        },
        controller: ProjectDirectiveController,
        replace: true,
        templateUrl: 'templates/directives/project/index.tpl',
        restrict: 'E'
    }

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
