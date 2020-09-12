require('@rails/ujs').start()
require('turbolinks').start()

const $ = require('jquery')
const Cookies = require('js-cookie')

$.ajaxSetup({
  dataType: 'json',
  contentType: 'application/json; charset=utf-8',
  beforeSend: (xhr) => xhr.setRequestHeader('Authorization', Cookies.get('Authorization'))
})

function nextCard(e) {
  if (e.type !== 'click' && e.code !== 'Space') { return false }
  $.get('/api/cards/rand', (card) => Turbolinks.visit(card.id))
  return false
}

$(document).on('turbolinks:load', () => {
  const controller = $('body').data('controller')
  const action = $('body').data('action')

  if (controller === 'cards' && action === 'show') {
    $('#card-next a').click(nextCard)
    $('body').keyup(nextCard)
  }

  if (controller === 'admin/home' && action === 'index') {
    $('#login-form').submit(() => {
      const password = $('#login-form').serializeArray().filter(({ name }) => name === 'password')[0].value
      Cookies.set('Authorization', password, { expires: 365 })
      Turbolinks.visit()
      return false
    })
  }
})
