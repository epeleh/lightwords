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

    $('#login-form input').keypress((e) => {
      if (e.key !== 'Enter' || !e.ctrlKey) { return }
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

  if (controller === 'admin/words' && action === 'index') {
    $('#upload-words-form').submit(() => {
      const inputs = $('#upload-words-form input')

      const words = inputs.map((_, x) => {
        const text = $(x).val().trim()
        if (text) { return { text } }
      }).get()

      $.post('/api/words', JSON.stringify({ words })).always((response) => {
        const data = response.responseJSON || response

        const validWords = data.filter((x) => !x.errors).map(({ text }) => text)
        inputs.filter((_, x) => validWords.includes($(x).val())).remove()

        const invalidWords = data.filter((x) => x.errors).reduce((obj, { text, errors }) => {
          obj[text] = errors
          return obj
        }, {})

        for (const [word, errors] of Object.entries(invalidWords)) {
          inputs.filter((_, x) => $(x).val().trim() === word)
            .attr('title', errors.text && errors.text.join('\n'))
            .addClass('invalid').delay(800).queue(function() { $(this).removeClass('invalid').dequeue() })
        }
      })

      return false
    })

    $('#upload-words-form input').keypress((e) => {
      if (e.key !== 'Enter') { return }
      e.ctrlKey ? $('#upload-words-form').submit() : $(e.target).next('input').focus()
      return false
    })

    $('#upload-words-form input').keyup((e) => {
      switch (e.key) {
        case 'ArrowDown': $(e.target).next('input').focus(); break
        case 'ArrowUp': $(e.target).prev('input').focus(); break
      }
    })

    $('#upload-words-form input').change((e) => {
      const inputs = $('#upload-words-form input')
      inputs.slice(0, -1).each((_, x) => $(x).val($(x).val().trim()))
      inputs.slice(0, -1).filter((_, x) => $(x).val().length === 0).each((_, x) => $(x).remove())
    })

    $('#upload-words-form input').on('paste', (e) => {
      const data = e.originalEvent.clipboardData.getData('text').split('\n').map((x) => x.trim()).filter((x) => x)
      let target = $(e.target)
      target.val(data.shift())

      $(data).each((_, line) => {
        const newInput = target.clone(true)
        newInput.removeAttr('title')
        newInput.val(line)

        target.after(newInput)
        target = target.next('input')
      })

      target.trigger('input').focus()
      return false
    })

    $('#upload-words-form input').on('input', (e) => {
      const inputs = $('#upload-words-form input')
      const target = $(e.target)
      target.removeAttr('title')

      if (target.index() === inputs.length - 1 && target.val().trim()) {
        const newInput = inputs.first().clone(true)
        newInput.removeAttr('title')
        newInput.val('')

        $('#upload-words-form button').before(newInput)
      } else if (target.index() === inputs.length - 2 && !target.val().trim()) {
        target.next('input').remove()
      }

      return false
    })
  }
})
