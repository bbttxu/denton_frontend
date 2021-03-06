 # show.coffee

define ["tcomb-validation", "moment"], (t, moment)->
  class Show
    constructor: (@date, @venue, @starts_at, @price, @source, @gigs, @time_is_unknown, @id)->

    time: ()=>
      moment(@starts_at).zone(moment().format('ZZ')).format "h:mm a"

    # timeIsCertain: ()=>
    #   @time_is_unknown is false


    isValid: ()=>

      validations = t.struct
        # date: t.Dat
        # id: t.Str
        gigs: t.Arr
        time_is_unknown: t.Bool

      # TODO can't figure out how to do the opposite of Nil :/
      # invalidations = t.struct
      #   venue: t.Nil

      data =
        # date: @date
        gigs: @gigs
        # id: @id
        time_is_unknown: @time_is_unknown
        # venue: @venue

      t.validate(data, validations).isValid() # and not t.validate(data, invalidations).isValid()

    hash: ()=>

