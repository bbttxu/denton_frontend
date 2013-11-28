# app.js.coffee

$ = jQuery
m = moment


dayViewModel = (day, shows)->
  self = this
  self.day = ko.observable(day)
  self.shows = ko.observable(shows)
  self.mmm = ko.computed ()->
    moment( self.day() ).format('MM')
  self.ddd = ko.computed ()->
    moment( self.day() ).format('dd')
  self.dd = ko.computed ()->
    moment( self.day() ).format('DD')
  self.link = ko.computed ()->
    "#/shows/" + self.day()

  self.soonish = ko.computed ()->
    if (moment().diff(moment(day), 'days') > -10)
      "soonish"

  self

artistViewModel = (artist)->
  self = this
  self.name = ko.observable artist.name
  self


venueViewModel = (venue)->
  self = this
  self.name = ko.observable venue.name
  self


showViewModel = (show)->
  self = this
  self.starts_at = ko.observable show.starts_at
  self.css_class = ko.computed ()->
    length = 0
    length = self.artists.length if self.artists
    "count-" + length

  self


showsViewModel = (calendar)->

  self = this
  self.calendar = ko.observable( calendar )
  self.current_date = ko.observable('')
  self.current_data = ko.observable([])

  get_show_json = (data)->

    console.log data
    self.current_data( data )

    venue_by_id = (id)->
      for venue in data.venues
        return venue if venue.id is id
      nil
    venue_by_id = _.memoize venue_by_id

    show_by_id = (id)->
      for show in data.shows
        return show if show.id is id
      nil
    show_by_id = _.memoize show_by_id

    gig_by_id = (id)->
      for gig in data.gigs
        return gig if gig.id is id
      nil
    gig_by_id = _.memoize gig_by_id

    artist_by_id = (id)->
      for artist in data.artists
        return artist if artist.id is id
      nil
    artist_by_id = _.memoize artist_by_id

    shows = []

    for show in data.shows
      sh = show_by_id show.id
      show_view = new showViewModel sh

      venue = venue_by_id show.venues
      venue = new venueViewModel venue

      show.venue = venue

      show.artists = []


      for gig_id in show.gigs
        gig = gig_by_id gig_id

        artist = artist_by_id gig.artists
        artist_view = new artistViewModel( artist )
        show.artists.push artist_view

      shows.push show

    self.current_data( shows )


  routes = Sammy '#calendar', ()->

    this.get '#/shows/:date', (req)->
      $('#day').show()
      $('#calendar').hide()

      date = req.params['date']
      $this = $('#' + date )
      self.current_date( date )

      $.getJSON 'http://denton.blackbeartheory.com/shows/' + date + '.json?callback=?', get_show_json

    this.get "#/", ()->
      $('#day').hide()
      $('#calendar').show()

  # routes.run("#/shows/" + moment().format('YYYY-MM-DD'))
  routes.run("#/")

  $('#calendar li').timespace()

  self

initial_ajax = ()->
  $.getJSON 'http://denton.blackbeartheory.com/shows.json?callback=?', (data, status)->

    calendar = _.groupBy data.shows, (item)->
      moment(item.starts_at).format("YYYY-MM-DD")

    names = []
    for day, shows of calendar
      names.push new dayViewModel( day, shows )

    # names = new dayViewModel( day, shows ) for day, shows of calendar


    ko.applyBindings new showsViewModel( names ), $('ul#calendar')[0]

    $('li.day').timespace()

$(document).ready initial_ajax





# calendarViewModel = (location, dates)->
#   self = this
#   self.location = ko.observable location
#   self.days = ko.observable dates
#   self

# artistViewModel = (artist)->
#   self = this
#   self.name = ko.observable artist.name
#   self

# gigViewModel = (gig)->
#   self = this
#   self.id = ko.observable gig.id
#   self.position = ko.observable gig.position
#   self

# showViewModel = (show)->
#   self = this
#   self.starts_at = ko.observable show.starts_at
#   self.css_class = ko.computed ()->
#     length = 0
#     length = self.artists.length if self.artists
#     "count-" + length

#   self

# venueViewModel = (venue)->
#   self = this
#   self.name = ko.observable venue.name
#   self


# handle_prev_calendar_click = (event)->
#   # event.preventDefault()
#   $trigger = $(this).parents('.calendar').prev('.calendar').find('header a.self')
#   $trigger.trigger 'click'
#   $prev = $trigger
#   $prev = $prev.prev('.calendar').find('header a') if $prev.prev '.calendar'
#   $.scrollTo( $trigger )

# handle_next_calendar_click = (event)->
#   event.preventDefault()
#   $target = $(this).parents('.calendar').next('.calendar').find('header a.self')
#   $target.trigger 'click'
#   $.scrollTo( $target )
#   # console.log $target

# handle_expanded_calendar_click = (event)->
#   $this = $(this)
#   $parent = $(this).parent('.calendar')

#   $parent.addClass('expanded')

#   if $parent.hasClass('expanded')
#     $parent.find('.content').show()
#   else
#     $parent.find('.content').hide()

# show_all_the_data = (d)->

#   venue_by_id = (id)->
#     for venue in d.venues
#       return venue if venue.id is id
#     nil
#   venue_by_id = _.memoize venue_by_id

#   show_by_id = (id)->
#     for show in d.shows
#       return show if show.id is id
#     nil
#   show_by_id = _.memoize show_by_id

#   gig_by_id = (id)->
#     for gig in d.gigs
#       return gig if gig.id is id
#     nil
#   gig_by_id = _.memoize gig_by_id

#   artist_by_id = (id)->
#     for artist in d.artists
#       return artist if artist.id is id
#     nil
#   artist_by_id = _.memoize artist_by_id

#   calendar = _.groupBy d.shows, (item)->
#     moment(item.starts_at).format("YYYY-MM-DD")

#   dates = _.map calendar, (key, value, item)->
#     classes = []
#     classes.push 'count-' + key.length
#     classes.push 'day-' + moment(value).format("ddd").toLowerCase()
#     classes.push 'soon' if moment().diff(moment(value), 'days') > -10

#     show_views = []

#     for show in key
#       sh = show_by_id show.id
#       show_view = new showViewModel sh

#       venue = venue_by_id show.venues
#       venue = new venueViewModel venue

#       show.venue = venue

#       show.artists = []


#       for gig_id in show.gigs
#         gig = gig_by_id gig_id

#         artist = artist_by_id gig.artists
#         artist_view = new artistViewModel( artist )
#         show.artists.push artist_view

#     id: value
#     count: key
#     month: moment(value).format("MMMM")
#     date: moment(value).format("DD")
#     day: moment(value).format('dddd')
#     count_class: classes.join(" ")
#     some_link: "#/shows/" + moment(value).format('YYYY-MM-DD')

#   all_data.calendar = dates

#   # ko.applyBindings all_data, $('#calendar')[0]
#   d.calendar = dates







#   # ko.applyBindings new calendarViewModel( "Denton, TX", dates ), $('#calendar')[0]

#   $('.calendar .next', $('#calendar')[0] ).on 'click', handle_next_calendar_click
#   $('.calendar .prev', $('#calendar')[0] ).on 'click', handle_prev_calendar_click
#   # $('.calendar header', $('#calendar')[0] ).on 'click', handle_expanded_calendar_click


# load_all_the_data = (data, status)->
#   show_all_the_data data

# ajax_all_the_data = ()->
#   $.getJSON 'http://denton.blackbeartheory.com/shows.json?callback=?', load_all_the_data

# $(document).ready ajax_all_the_data


# $(document).ready ()->
#   # app = Davis ()->

#   #   this.get '/denton/shows/:date', (req)->
#   #     $this = $('#' + req.params['date'] )
#   #     $('.calendar').not( $this ).hide()
#   #     $this.show()
#   #     console.log $this
#   #     # alert("Hello " + req.params['date'])


#   #   this.get "/denton", ()->
#   #     $('.calendar').removeClass('expanded').show().find('.content').hide()




#   # app.start("/denton")

#   app = Sammy '#calendar', ()->

#     this.get '#/shows/:date', (req)->
#       $this = $('#' + req.params['date'] )
#       $('.calendar').hide()
#       $('.calendar.expanded').removeClass('expanded').hide().find('.content').hide()
#       $this.addClass('expanded').show().find('.content').show()

#     this.get "#/", ()->
#       console.log 'default'
#       $('.calendar').removeClass('expanded').show().find('.content').hide()

#   app.run("#/shows/" + moment().format('YYYY-MM-DD'))

# load_all_the_data = (data, status)->
#   show_all_the_data data

# ajax_all_the_data = ()->
#   $.getJSON 'http://denton-api1.blackbeartheory.com:5000/shows.json?callback=?', load_all_the_data

# $(document).ready ajax_all_the_data

