<div class="container" id="netsoul">
  <fieldset>
    <legend>Real-Time Informations</legend>
    <div class="center" style="margin-bottom: 10px">
      <div class="btn-group">
	<label class="btn btn-default" ng-model="filters.states[key]" ng-repeat="(key, value) in filters.states" btn-checkbox>{{key}}</label>
      </div>
      <div class="btn-group">
	<label class="btn btn-default" ng-model="filters.promos[key]" ng-repeat="(key, value) in filters.promos" btn-checkbox>Promo {{key}}</label>
      </div>
    </div>

    <div class="row">
      <h3 class="col-md-12 center" ng-hide="netsoul.length">No one found :-(</h3>
      <div class="col-xs-3 col-md-1" ng-repeat="user in netsoul">
	<div class="thumbnail">
	  <a href="https://intra.epitech.eu/user/{{user.login}}">
	    <img style="width:100%" ng-src="{{user.picture}}" data-toggle="tooltip" title="{{login}}"
		 onerror="this.onerror=null;this.src=''"/>
	  </a>
	  <div style="line-height: 15px; font-size: 12px; text-align: center ; width: 100%;height: 15px;background-color: {{user.color}}">{{user.login}}</div>
	</div>
      </div>
    </div>
    <div class="right spacer">
      <b> Total: {{netsoul.length}}</b>
    </div>
  </fieldset>
  <fieldset class="spacer" ng-show="hallOfFame.length == 10">
    <legend>Hall of Fame</legend>
    <div class="row">
      <halloffame picture="hallOfFame[0].picture" login="hallOfFame[0].login" total="hallOfFame[0].total" offset="5" icon="'fa-trophy'" />
    </div>
    <div class="row">
      <halloffame picture="hallOfFame[1].picture" login="hallOfFame[1].login" total="hallOfFame[1].total" offset="4" icon="'fa-thumbs-up'" />
      <halloffame picture="hallOfFame[2].picture" login="hallOfFame[2].login" total="hallOfFame[2].total" offset="0" />
    </div>
    <div class="row">
      <halloffame picture="hallOfFame[3].picture" login="hallOfFame[3].login" total="hallOfFame[3].total" offset="3" />
      <halloffame picture="hallOfFame[4].picture" login="hallOfFame[4].login" total="hallOfFame[4].total" offset="0" />
      <halloffame picture="hallOfFame[5].picture" login="hallOfFame[5].login" total="hallOfFame[5].total" offset="0" />
    </div>
    <div class="row">
      <halloffame picture="hallOfFame[6].picture" login="hallOfFame[6].login" total="hallOfFame[6].total" offset="2" />
      <halloffame picture="hallOfFame[7].picture" login="hallOfFame[7].login" total="hallOfFame[7].total" offset="0" />
      <halloffame picture="hallOfFame[8].picture" login="hallOfFame[8].login" total="hallOfFame[8].total" offset="0" />
      <halloffame picture="hallOfFame[9].picture" login="hallOfFame[9].login" total="hallOfFame[9].total" offset="0" />
    </div>
  </fieldset>
</div>
