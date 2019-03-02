(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
      :parameters (?r - robot ?l - location ?lo - location)
      :precondition (and (free ?r) (connected ?l ?lo) (at ?r ?l) (no-robot ?lo))
      :effect (and (at ?r ?lo) (not (no-robot ?lo)) (no-robot ?l))
   )

    (:action robotMoveWithPallette
       :parameters (?r - robot ?l - location ?lo - location ?p - pallette)
       :precondition (and  (connected ?l ?lo) (at ?r ?l) (at ?p ?l) (no-pallette ?lo) (no-robot ?lo))
       :effect (and (not (free ?r)) (no-pallette ?l) (no-robot ?l) (at ?r ?lo) (at ?p ?lo) (not (no-robot ?lo)) (not (no-pallette ?lo)))
    )

    (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?sh - shipment ?sal - saleitem ?pal - pallette ?order - order)
      :precondition (and (contains ?pal ?sal) (at ?pal ?l) (orders ?order ?sal) (ships ?sh ?order) (packing-location ?l) (available ?l))
      :effect (and (not (contains ?pal ?sal)) (unstarted ?sh) (includes ?sh ?sal))
    )

    (:action completeShipment
      :parameters (?sh - shipment ?order - order ?l - location)
      :precondition (and (started ?sh) (packing-at ?sh ?l) (ships ?sh ?order) (not (unstarted ?sh)) (not (complete ?sh)))
      :effect (and (not (started ?sh)) (complete ?sh) (not (packing-at ?sh ?l)) (available ?l))
    )

)
