api_url = 'http://localhost:3000/api/v1/'
datetime_now = new Date()
cookiesExpires = new Date(datetime_now.getFullYear()+1, datetime_now.getMonth(), datetime_now.getDate())
Alert =
  unknow: (message = 'Unknow error')->
    alert message

############### Get data from the server ###############
$$user = null
$$session_key = null
$$is_auth = null
$$serverCallback = null
$$User = (callback = null)->
  $.ajax({
    url: api_url+'/account/user'
    method: 'get',
    cache: false,
    async: true,
    data: {
      session_key: $.cookie('session_key')
    }
    success: (res)->
      $.cookie('session_key', res.session_key, { expires: 365 })
      unless callback == null
        callback(res)
      unless $$serverCallback == null
        $$serverCallback(res)
      $$user = res.user
      $$session_key = res.session_key
      $$is_auth = res.is_auth
  })
#$$serverCallback = (res)->
#  console.log res.is_auth
########################################################
########################################################

# Sign up page.
if $("html[ng-app='sign_up']").length == 1
  $$User()
  $$serverCallback = (res)->
    if res.is_auth == true
      location.href = '/'

  $('.input-group.date').datepicker({
    format: 'dd.mm.yyyy',
    startDate: new Date(1900, 0, 1),
    endDate: new Date(2012, 11, 31)
  })

  angular.module('sign_up', ['ngCookies'])
  .controller 'sign_up', ($scope, $http, $cookies)->
    $scope.title = 'Sign up'

    $scope.form =
      first_name: ''
      last_name: ''
      birthday: ''
      gender: ''
      username: ''
      password: ''
      inviter: ''
      email: ''
      language: navigator.language.substr(0,2)
      session_key: $cookies.get('session_key')
    $scope.reset = ->
      $scope.form['first_name'] = ''
      $scope.form['last_name'] = ''
      $scope.form['birthday'] = ''
      $scope.form['gender'] = ''
      $scope.form['username'] = ''
      $scope.form['password'] = ''
      $scope.form['inviter'] = ''
      $scope.form['email'] = ''

    $scope.success = (response)->
      try
        r = response.data
        $cookies.put('session_key', r.session_key, {
          expires: cookiesExpires
        })
        if r.error == 3
          angular.forEach(r.body, (value, key)->
            angular.forEach(value, (v)->
              $('div.error.'+key+'.'+v).show()
              if key == 'birthday'
                $('input#'+key).parent().parent().addClass('has-warning')
              else
                $('input#'+key).parent().addClass('has-warning')
            )
          )
        else if r.error == 0
          $scope.reset()
          location.href = '/'
        else
          Alert.unknow()
      catch error

    $scope.submit = ->
      $('div.error').hide()
      $('div.form-group').removeClass('has-warning')
      $http.post(api_url+'/account/sign_up', $scope.form).then($scope.success, Alert.unknow)

# Sign in page.
if $("html[ng-app='sign_in']").length == 1
  $$User()
  $$serverCallback = (res)->
    if res.is_auth == true
      location.href = '/'

  angular.module('sign_in', ['ngCookies'])
  .controller 'sign_in', ($scope, $http, $cookies)->
    $scope.title = 'Sign in'

    $scope.form =
      username: ''
      password: ''
      session_key: $cookies.get('session_key')

    $scope.success = (response)->
      try
        r = response.data
        $cookies.put('session_key', r.session_key, {
          expires: cookiesExpires
        })
        if r.error == 0
          location.href = '/'
        else if r.error == 2
          $('div.alert').show()
        else
          Alert.unknow()
      catch error

    $scope.submit = ->
      $('div.alert').hide()
      $http.post(api_url+'/account/sign_in', $scope.form).then($scope.success, Alert.unknow)

# Recovery page.
if $("html[ng-app='recovery']").length == 1
  angular.module('recovery', ['ngCookies'])
  .controller 'recovery', ($scope, $http, $cookies)->
    $scope.title = 'Recovery'

    $scope.form =
      email: ''
      session_key: $cookies.get('session_key')

    $scope.success = (response)->
      try
        r = response.data
        if r.error == 0
          $('div.alert.good').show()
        else if r.error == 2
          $('div.alert.bad').show()
        else
          Alert.unknow()
      catch error

    $scope.submit = ->
      $('div.alert').hide()
      $http.post(api_url+'/account/recovery', $scope.form).then($scope.success, Alert.unknow)

# Sign out page.
if $("html.sign_out").length == 1
  $.ajax({
    url: api_url+'/account/sign_out',
    method: 'get',
    data: {
      session_key: $.cookie('session_key')
    }
    success: (res)->
      if res.error == 0
        location.href = 'sign_in.html'
      else
        Alert.unknow()
    error: ->
      Alert.unknow()
  })

# Index page.
if $("html[ng-app='index']").length == 1
  app = angular.module('index', ['ngCookies', 'ngRoute'])
  app.config(($routeProvider)->
    $routeProvider
    .when('/', {
      templateUrl: 'main.html'
    })
    .when('/dialog', {
      templateUrl: 'dialog.html'
    })
    .when('/my_dialogs', {
      templateUrl: 'my_dialogs.html'
    })
  )
  $mainScope = null
  $user = null
  app.controller 'index', ($scope, $http, $cookies)->
    $mainScope = $scope
    $$User()
    $$serverCallback = (res)->
      if res.is_auth == false
        location.href = 'sign_in.html'
      else
        $user = res.user
        $scope.user = $user
        $scope.$apply()
  app.controller 'main', ($scope, $http, $cookies)->
    $scope.name = 'imbay'
    $mainScope.title = $user.first_name+' '+$user.last_name

  app.controller 'dialog', ($scope, $http, $cookies)->
    $mainScope.title = 'Dialog'
    $scope.dialogs = []
    $http.get(api_url+'/dialog/list?session_key='+$cookies.get('session_key')).then((res)->
      res = res.data
      if res.error == 0
        $scope.dialogs = res.body
    , Alert.unknow)

  app.controller 'my_dialogs', ($scope, $http, $cookies)->
    $mainScope.title = 'My dialogs'
    $scope.dialogs = []
    $http.get(api_url+'/dialog?session_key='+$cookies.get('session_key')).then((response)->
      res = response.data
      if res.error == 0
        $scope.dialogs = res.body
    , Alert.unknow)

    $scope.form =
      is_anon: false,
      title: '',
      session_key: $cookies.get('session_key')
    $scope.reset = ->
      $scope.form.is_anon = false
      $scope.form.title = ''
    $scope.success = (response)->
      element = $("div[ng-controller='my_dialogs']")
      element.find('form div.error').hide()
      try
        r = response.data
        if r.error == 0
          $http.get(api_url+'/dialog?session_key='+$cookies.get('session_key')).then((response)->
            r = response.data
            $scope.dialogs = r.body
            $scope.reset()
          , Alert.unknow)
        else if r.error == 3
          $scope.reset()
          angular.forEach(r.body, (value, key)->
            if key == 'dialog'
              if 'limit' in value
                bootbox.alert({
                  title: 'Error'
                  message: '<b>Limit</b>',
                  size: 'small',
                  backdrop: true,
                  buttons: {
                    ok: {
                      className: 'btn-danger',
                    }
                  }
                })
            else if key == 'title'
              if 'min' in value
                element.find('form div.error.title.min').show()
              else if 'max' in value
                element.find('form div.error.title.max').show()
          )
        else
          Alert.unknow()
      catch error
    $scope.delete = (id)->
      bootbox.confirm({
        message: '<b>Delete this dialog?</b>'
        size: 'small',
        buttons: {
          cancel: {
            label: 'no',
            className: 'btn-danger'
          }
          confirm: {
            label: 'yes',
            className: 'btn-success'
          }
        },
        callback: (result)->
          if result == true
            $http.post(api_url+'/dialog/delete', { dialog_id: id, session_key: $cookies.get('session_key') }).then((res)->
              res = res.data
              if res.error == 0
                # $('div.row.dialog_row div.dialog_id_'+id).remove()
                index = _.findIndex($scope.dialogs, { id: id })
                $scope.dialogs.splice(index, 1)
              else if res.error == 4
                bootbox.alert({
                  title: 'Error'
                  message: '<b>This dialog deleted</b>',
                  size: 'small',
                  backdrop: true,
                  buttons: {
                    ok: {
                      className: 'btn-danger',
                    }
                  }
                })
            , Alert.unknow)
      })
    $scope.submit = ->
      $http.post(api_url+'/dialog/new', $scope.form).then($scope.success, Alert.unknow)
