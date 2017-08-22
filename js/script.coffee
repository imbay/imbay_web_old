api_url = 'http://localhost:3000/v1/'
datetime_now = new Date()
cookiesExpires = new Date(datetime_now.getFullYear()+1, datetime_now.getMonth(), datetime_now.getDate())
Alert =
  unknow: (message = 'Unknow error')->
    alert message

############### Get data from the server ###############
user = null
session_key = null
is_auth = null
serverCallback = null
User = (callback = null)->
  $.ajax({
    url: api_url+'/account/user'
    method: 'post',
    cache: false,
    async: true,
    data: {
      session_key: $.cookie('session_key')
    }
    success: (res)->
      $.cookie('session_key', res.session_key, { expires: 365 })
      unless callback == null
        callback(res)
      unless serverCallback == null
        serverCallback(res)
      user = res.user
      session_key = res.session_key
      is_auth = res.is_auth
  })
#serverCallback = (res)->
#  console.log res.is_auth
########################################################
########################################################

# Sign up page.
if $("html[ng-app='sign_up']").length == 1
  User()
  serverCallback = (res)->
    if res.is_auth == true
      location.href = 'index.html'

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
          location.href = 'index.html'
        else
          Alert.unknow()
      catch error

    $scope.submit = ->
      $('div.error').hide()
      $('div.form-group').removeClass('has-warning')
      $http.post(api_url+'/account/sign_up', $scope.form).then($scope.success, Alert.unknow)

# Sign in page.
if $("html[ng-app='sign_in']").length == 1
  User()
  serverCallback = (res)->
    if res.is_auth == true
      location.href = 'index.html'

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
          location.href = 'index.html'
        else if r.error == 2
          $('div.alert').show()
        else
          Alert.unknow()
      catch error

    $scope.submit = ->
      $('div.alert').hide()
      $http.post(api_url+'/account/sign_in', $scope.form).then($scope.success, Alert.unknow)

# Sign in page.
if $("html[ng-app='index']").length == 1
  User()
  serverCallback = (res)->
    if res.is_auth == false
      location.href = 'sign_in.html'

  angular.module('index', ['ngCookies'])
  .controller 'index', ($scope, $http, $cookies)->
    $scope.title = 'Index'

# Sign out page.
if $("html.sign_out").length == 1
  $.ajax({
    url: api_url+'/account/sign_out',
    method: 'post',
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
