module MessagesHelper

  def get_message_value(attachable, message)
    attachable.unique_identifier + " " + message.body.sub(attachable.unique_identifier, '').strip
  end

    def process_message_body(body)
    body.gsub(/(^@|\s@)(\w[\w\.\-_@]+)/, ' @<a href="/' + '\2' + '"><strong>\2</strong></a>').gsub(/(^%|\s%)(\w[\w\.\-_@]+)/, ' %<a href="/groups/' + '\2' + '/dashboard' + '"><strong>\2</strong></a>').gsub(/(^|[\s"'`<\[(])(((https?|ftp):\/\/([\d\w]+:[\d\w]+@)?)?([-.\d\w]+\.(a[cdefgilmnoqrstuwxz]|b[abdefghijmnorstvwyz]|c[acdfghiklmnoruvxyz]|d[ejkmoz]|e[cegrstu]|f[ijkmor]|g[abdefghilmnpqrstuwy]|h[kmnrtu]|i[delmnoqrst]|j[emop]|k[eghimnprwyz]|l[abcikrstuvy]|m[acdeghklmnopqrstuvwxyz]|n[acefgilopruz]|om|p[aefghklmnrstwy]|qa|r[eosuw]|s[abcdeghijklmnortuvyz]|t[cdfghjklmnoprtvwz]|u[agksyz]|v[aceginu]|w[fs]|y[etu]|z[amw]|aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel)(\b|\W(<!&|=)(?!\.\s|\.{3}).*))[\S]*)(|\s|$)/) { |match| link = match !~ /(https?:\/\/|ftp:\/\/)/ ? "http://#{match.strip.gsub(/^(\[|\]|\"|\'|\(|\)|\<|\>|\.|\,|\?)+/,'').gsub(/(\[|\]|\"|\'|\(|\)|\<|\>|\.|\,|\?)+$/,'')}" : "#{match.strip.gsub(/^(\[|\]|\"|\'|\(|\)|\<|\>|\.|\,|\?)+/,'').gsub(/(\[|\]|\"|\'|\(|\)|\<|\>|\.|\,|\?)+$/,'')}"; '<strong style="font-size: 14px;">'+ link_to(match, link, :popup => true) +'</strong>' }
  end

#  def process_message_body_with_absolute_path(body)
#    body.gsub(/(^@|\s@)(\w[\w\.\-_@]+)/, ' @<a href="' + HOST + '/' + '\2' + '"><strong>\2</strong></a>').gsub(/(^%|\s%)(\w[\w\.\-_@]+)/, ' %<a href="' + HOST + '/groups/' + '\2' + '/dashboard"><strong>\2</strong></a>').gsub(/(^|[\s"'`<\[(])(((https?|ftp):\/\/([\d\w]+:[\d\w]+@)?)?([-.\d\w]+\.(a[cdefgilmnoqrstuwxz]|b[abdefghijmnorstvwyz]|c[acdfghiklmnoruvxyz]|d[ejkmoz]|e[cegrstu]|f[ijkmor]|g[abdefghilmnpqrstuwy]|h[kmnrtu]|i[delmnoqrst]|j[emop]|k[eghimnprwyz]|l[abcikrstuvy]|m[acdeghklmnopqrstuvwxyz]|n[acefgilopruz]|om|p[aefghklmnrstwy]|qa|r[eosuw]|s[abcdeghijklmnortuvyz]|t[cdfghjklmnoprtvwz]|u[agksyz]|v[aceginu]|w[fs]|y[etu]|z[amw]|aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel)(\b|\W(<!&|=)(?!\.\s|\.{3}).*))[\S]*)(|\s|$)/) { |match| link = match !~ /(https?:\/\/|ftp:\/\/)/ ? "http://#{match.strip.gsub(/^(\[|\]|\"|\'|\(|\)|\<|\>|\.|\,|\?)+/,'').gsub(/(\[|\]|\"|\'|\(|\)|\<|\>|\.|\,|\?)+$/,'')}" : "#{match.strip.gsub(/^(\[|\]|\"|\'|\(|\)|\<|\>|\.|\,|\?)+/,'').gsub(/(\[|\]|\"|\'|\(|\)|\<|\>|\.|\,|\?)+$/,'')}"; '<strong style="font-size: 14px;">'+ link_to(match, link, :popup => true) +'</strong>' }
#  end
#
#  def process_message_body_timestamp(message)
#    link_to "#{message.created_at}", show_message_url(message, :anchor => message.root? ? "parent_message_#{message.id}_body" : "descendant_message_#{message.id}_body"), :class => "timestamps"
#  end
#
#  def process_url(text, url)
#    auto_link(url, :urls, :target => "_blank") do |link|
#      text
#    end
#  end
#
#  def process_links(body)
#    auto_link(body, :all, :target => "_blank") do |link|
#      "<strong style='font-size: 14px;'>#{link}</strong>"
#    end
#  end

  def process_emails(body)
    auto_link(body, :email_addresses, :target => "_blank") do |link|
      "<strong style='font-size: 14px;'>#{link}</strong>"
    end
  end

end
