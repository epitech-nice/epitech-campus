<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/{{cityCode}}">Epitech Campus 0.2</a>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
                <li ng-class="{active: '' == page}"><a href="/{{cityCode}}">Home</a></li>
                <li ng-show="cityCode" class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        Modules
                        <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <li ng-repeat="(url, name) in menuModule" ng-class="{active: url == page}">
                            <a href="{{cityCode}}/{{url}}">
                                {{name}}
                            </a>
                        </li>
                    </ul>
                </li>
                <li ng-repeat="(url, name) in menu" ng-class="{active: url == page}" ng-show="cityCode">
                    <a href="{{cityCode}}/{{url}}">
                        {{name}}
                    </a>
                </li>
            </ul>
            <form class="navbar-form navbar-right">
                <select class="form-control" ng-model="cityCode" ng-change="onCitySelect(cityCode)">
                    <option value="">----</option>
                    <option value="FR/NCE">Nice</option>
                    <option value="FR/MPL">Montpellier</option>
                </select>
            </form>
        </div>
    </div>
</div>
