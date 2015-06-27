
formatstr = (href,  page, num) ->
  """<a href="#{href}-#{page}">#{num}</a>"""

$.pager = (href, count, now, limit) ->
  if not count
    return ''
  now = parseInt(now)
  now = 1  if now <= 0
  end = Math.floor((count + limit - 1) / limit)
  now = end  if now > end
  scope = 2
  total = Math.floor((count + limit - 1) / limit)
  if total > 1
    merge_begin = false
    merge_end = false
    omit_len = scope + 3
    if total <= (scope + omit_len + 1)
      begin = 1
      end = total
    else
      if now > omit_len
        merge_begin = true
        begin = now - scope
      else
        begin = 1
      if (total - now) >= omit_len
        merge_end = true
        end = now + scope
      else
        end = total
      if (end - begin) < (scope * 2)
        if now <= omit_len
          end = Math.min(begin + scope * 2, total)
        else
          begin = Math.max(end - scope * 2, 1)
        unless begin > omit_len
          merge_begin = false
          begin = 1
        unless (total - end) >= omit_len
          merge_end = false
          end = total
  links = []
  if now > 1
    pageLink = formatstr(href,  now - 1, "&lt")
    links.push pageLink
  else
    links.push "<span class=\"plt\">&lt;</span>"
  if merge_begin
    pageLink = formatstr(href, 1, 1)
    pageLink += "..."
    links.push pageLink
    show_begin_mid = false
    show_begin_mid = Math.floor(begin / 2)  if begin > 8
    if show_begin_mid
      pageLink = formatstr(href, show_begin_mid, show_begin_mid)
      pageLink += "..."
      links.push pageLink
  i = begin
  while i < now
    pageLink = formatstr(href, i, i)
    links.push pageLink
    i++
  spanNow = "<span class=\"now\">%s</span>"
  spanNow = spanNow.replace(/%s/, now)
  links.push spanNow
  i = now + 1
  while i < end + 1
    pageLink = formatstr(href, i, i)
    links.push pageLink
    i++
  links.push "···"  if merge_end
  if now < total
    pageLink = formatstr(href, now + 1, "&gt")
    links.push pageLink
  else
    links.push "<span class=\"pgt\">&gt;</span>"
  htm = ""
  i = 0
  while i < links.length
      htm += links[i]
      i++
  
  return htm
