class Application
  STRONG = 'ABCDEFGHJKLMNPQRSTUVWabcdefghijkmnopqrstuvw0123456789+/-_*()[]{}'
  WEAK =   'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  LENGTH = 12

  hash: (password, domain) ->
    key = @encrypt(password)
    hash = @encrypt(key + domain)

    hash = base64_encode(hash, STRONG)
    hash = hash.substring(0, LENGTH)

    $("#hash").text(hash)

  encrypt: (data) ->
   hex_sha256(data)

class Url
  constructor: (url) ->
    @url_ = url
    
  url: ->
    @url_
    
  hostname: ->
    l = document.createElement("a")
    l.href = @url()
    l.hostname

$(document).ready ->
  chrome.tabs.getSelected null, (tab) ->
    url = new Url(tab.url)
    $("#domain").val(url.hostname())
  if localStorage["password"] != undefined
    $("#password").val(localStorage["password"])
  if $("#password").val() && $("#domain").val()
    app = new Application()
    app.hash $("#password").val(), $("#domain").val()
  $('#dash_form').submit (e) ->
    app = new Application()
    app.hash $("#password").val(), $("#domain").val()  
    localStorage["password"] = $("#password").val()
    e.preventDefault();