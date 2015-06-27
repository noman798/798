avalon.filters.txt2html = $.txt2html



window.V = avalon.vmodels

window.View = (id, o, view)->
    o['$id'] = id
    v = avalon.define o
    avalon.scan()
    view?(v)
    v
