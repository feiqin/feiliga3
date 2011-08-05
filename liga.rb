load "caculator.rb"
require 'net/http'

bot_token = "ktjgsqm94ygqfx8n6l22j1j7"

  def createTeams()
    teamsList = Array.new
    teamsList.push Team.new("FC Bayern Müchen", "40", 1)
    teamsList.push Team.new("Borussia Dortmund", "7", 2)
    teamsList.push Team.new("FC Schalke 04", "9", 3)
    teamsList.push Team.new("Bayer Leverkusen", "6", 4)
    teamsList.push Team.new("Hamburger SV", "100", 5)
    teamsList.push Team.new("Hannover 96", "55", 6)
    teamsList.push Team.new("1899 Hoffenheim", "123", 7)
    teamsList.push Team.new("VfL Wolfsburg", "131", 8)
    teamsList.push Team.new("1. FC Köln", "65", 9)
    teamsList.push Team.new("Werder Bremen", "134", 10)
    teamsList.push Team.new("VfB Stuttgart", "16", 11)
    teamsList.push Team.new("1. FC Nürnberg", "79", 12)
    teamsList.push Team.new("Hertha BSC", "54", 13)
    teamsList.push Team.new("1. FSV Mainz 05", "81", 14)
    teamsList.push Team.new("Bor. Mönchengladbach", "87", 15)
    teamsList.push Team.new("1. FC Kaiserslautern", "76", 16)
    teamsList.push Team.new("FC Augsburg", "95", 17)
    teamsList.push Team.new("SC Freiburg", "112", 18)
    return teamsList
  end
teams = createTeams()

caculator = Caculator.new(teams)

#matches = caculator.getMatches()
#next_matches = Array.new
#(0..matches.length-1).each do |i|
#  line = matches[i]

#  next_matches.push line.to_s.split("hostId",2)[1].split("id")[1].split("season")[0]

#end

next_matches = [14008, 14009, 14010,14011,14012,14013,14014,14015,14016]

http = Net::HTTP.new('botliga.de',80)

next_matches.each do |match_id|
  
  # insert smart voodoo calculations here
  result = "#{caculator.getResult(match_id)}"
  puts result

  # post your guess
  response, data = http.post('/api/guess',"match_id=#{match_id}&result=#{result}&token=#{bot_token}")

  # "201 Created" (initial guess) or "200 OK" (guess update)
  puts "#{response.code} #{data}"
end
