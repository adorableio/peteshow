Faker  = require('faker')
cs     = require('calmsoul')
moment = require('moment')

randomString = (length, chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') ->
  result = ''
  for i in [length..0]
    result += chars[Math.round(Math.random() * (chars.length - 1))]
  return result

module.exports =
  random:
    date: ->
      cs.log('DeweyHelpers::date')
      moment(Faker.date.future(1)).format('YYYY-MM-DD')

    # General
    letters: (n = 8) ->
      cs.log('DeweyHelpers::letters')
      randomString(n)

    # Numbers
    number: (n = 8) ->
      cs.log('DeweyHelpers::number')
      Faker.random.number({min: 0, max: n})

    phoneNumber: (n = 5) ->
      cs.log('DeweyHelpers::phoneNumber')
      Faker.phone.phoneNumberFormat(n)

    # People
    #
    name: ->
      cs.log('DeweyHelpers::firstName')
      Faker.name.findName()

    firstName: ->
      cs.log('DeweyHelpers::firstName')
      Faker.name.firstName()

    lastName: ->
      cs.log('DeweyHelpers::lastName')
      Faker.name.lastName()

    companyName: ->
      cs.log('DeweyHelpers::companyName')
      Faker.company.companyName()

    email: ->
      cs.log('DeweyHelpers::email')
      Faker.internet.email()

    # Address
    #
    street: ->
      cs.log('DeweyHelpers::street')
      Faker.address.streetAddress()

    secondary: ->
      cs.log('DeweyHelpers::secondary')
      Faker.address.secondaryAddress()

    city: ->
      cs.log('DeweyHelpers::city')
      Faker.address.city()

    county: ->
      cs.log('DeweyHelpers::county')
      Faker.address.county()

    state: ->
      cs.log('DeweyHelpers::state')
      Faker.address.state({full: true})

    stateAbbr: ->
      cs.log('DeweyHelpers::stateAbbr')
      Faker.address.stateAbbr()

    zipCode: (n = 5) ->
      cs.log('DeweyHelpers::zipCode')
      Faker.address.zipCode(n)

    # Lorem
    catchPhrase: (n = 4) ->
      cs.log('DeweyHelpers::catchPhrase')
      Faker.company.catchPhrase()

    sentences: (n = 5) ->
      cs.log('DeweyHelpers::sentences')
      Faker.lorem.sentences(n)
