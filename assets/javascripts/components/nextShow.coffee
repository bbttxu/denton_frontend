define ['react', 'underscore', 'moment'], (React, _, moment)->

  {a, div, h2, small, h1} = React.DOM

  class NextShow extends React.Component
    render: ->
      venue = this.props.venue

      link = "#/shows/#{moment(venue.next_show).format('YYYY-MM-DD')}"

      a {href: link}, moment(venue.next_show).calendar()

  React.createFactory NextShow
