require('@rails/ujs').start()
require('turbolinks').start()

const $ = require('jquery')
const Cookies = require('js-cookie')

$.ajaxSetup({
  dataType: 'json',
  contentType: 'application/json; charset=utf-8',
  beforeSend: (xhr) => xhr.setRequestHeader('Authorization', Cookies.get('Authorization'))
})

const viewedCards = new Set()

function currentCardId() {
  if (!/^\/(c|cards)\/\d*/.test(location.pathname)) { return null }
  return +location.pathname.split('/').slice(-1)
}

function nextCard(e) {
  if (e.type !== 'click' && e.code !== 'Space') { return false }

  if (Array.from(viewedCards).slice(0, -1).includes(currentCardId())) {
    history.forward()
  } else {
    $.get('/api/cards/rand', (card) => {
      viewedCards.delete(card.id)
      Turbolinks.visit(card.id)
    })
  }

  return false
}

$(document).on('turbolinks:load', () => {
  const controller = $('body').data('controller')
  const action = $('body').data('action')

  if (controller === 'cards' && action === 'show') {
    viewedCards.add(currentCardId())
    $('#card-next a').click(nextCard)
    $('body').keyup(nextCard)
  }

  if (controller === 'admin/home' && action === 'index') {
    $('#login-form').submit(() => {
      const password = $('#login-form').serializeArray().filter(({ name }) => name === 'password')[0].value.trim()
      Cookies.set('Authorization', password, { expires: 365 })
      location.reload()
      return false
    })

    $('#logout-link').click(() => {
      Cookies.remove('Authorization')
      location.reload()
      return false
    })
  }
})
