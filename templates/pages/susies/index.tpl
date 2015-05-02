<h1>Susie</h1>
<div class="row">
  <div class="col-md-4 col-md-offset-4">
    <table class="table table-bordered">
      <tr>
	<th>Promo</th>
	<th>Nb pour valider</th>
      </tr>
      <tr ng-repeat="(promo, count) in toDo">
	<td>{{promo}}</td>
	<td><span class="badge">{{count}}</span></td>
      </tr>
    </table>
  </div>
</div>
<div class="row">
  <div class="col-md-8 col-md-offset-2">
    <table class="table table-striped table-bordered table-hover">
      <thead>
	<tr>
	  <th>
	    <input type="search" class="form-control" ng-model="filters.login" ng-keyup="applyFilters()"/>
	  </th>
	  <th>
	    <select class="form-control" class="input-medium" id="promo" ng-model="filters.promo" ng-change="applyFilters()">
	      <option value="">Promo - All</option>
	      <option ng-repeat="promo in promos" value="{{promo}}">Promo - {{promo}}</option>
	    </select>
	  </th>
	  <th>Presences</th>
	  <th>Statut</th>
	</tr>
      </thead>
      <tbody id="tbody">
	<tr ng-repeat="user in users">
	  <td>{{user.login}}</td>
	  <td>{{user.promo}}</td>
	  <td>{{user.nbSusies}}</td>
	  <td>
	    <span class="label label-success" ng-show="user.toDo == 0">Success</span>
	    <span class="label label-warning" ng-show="user.toDo > 0">{{user.toDo}} to go</span>
	  </td>
	</tr>
      </tbody>
    </table>
  </div>
</div>
