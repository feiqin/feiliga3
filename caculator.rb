class Caculator

  require 'rubygems'
  require 'json'
  require 'net/http'

  load "team.rb"

  attr_accessor :teams, :matches

  def initialize(teamsList)

    @matches = getMatches()

    @teams = teamsList

  end

  def getMatches()

    url = "http://botliga.de/api/matches/2011"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    result = JSON.parse(data)

    return result
  end

  def getResult(matchId)

    matchTeams = getMatchTeams(matchId)

    homeTeamId = getHomeTeamId(matchTeams, matchId)
    awayTeamId = getAwayTeamId(matchTeams, matchId)

    return caculate(homeTeamId, awayTeamId)

  end

  def getMatchTeams(matchId)
    completeId = "id"+matchId.to_s
    (0..@matches.length-1).each do |i|
      line = @matches[i]
      if line.to_s.include?completeId
        return line.to_s
      end
    end
  end

  def getHomeTeamId(m, mid)
    m = m.split("id"+mid.to_s, 2)[0]
    m = m.split("hostId", 2)[1]
    return m
  end

  def getAwayTeamId(m, mid)
    m = m.split("id"+mid.to_s, 2)[1]
    m = m.split("guestId", 2)[1]
    m = m.split("hostName", 2)[0]
    return m
  end

  def caculate(homeTeamId, awayTeamId)
 
    homeTeam = findTeamById(homeTeamId)
    gastTeam = findTeamById(awayTeamId)
    

    matchname = homeTeam.name + " : " + gastTeam.name
    puts matchname

    different = homeTeam.rank - gastTeam.rank
    
    if different.abs < 2
      factor = rand(1000)
      if factor > 700
        different = 0
      end
    elsif different.abs < 7
      if rand(1000) > 900
	different = 0
      end
    else
      factor = rand(1000)
      if rand(1000) < 50
        different = 0
      end
    end

    basicGoals = 4
    if rand(1000) > 950
      basicGoals = 5
    elsif rand(1000) < 25
      basicGoals = 6
    end

    if different < 0
      homegoals = rand(basicGoals)
      if homegoals == 0
	homegoals = homegoals + 1
        gastgoals = 0
      elsif homegoals == 1
	gastgoals = 0
      else
        gastgoals = rand(homegoals-1)
      end
    elsif different == 0
      homegoals = rand(basicGoals-1)
      gastgoals = homegoals
    else
      gastgoals = rand(basicGoals)
      if gastgoals == 0
	gastgoals = gastgoals + 1
	homegoals= 0
      elsif gastgoals == 1
        homegoals= 0
      else
	homegoals= rand(gastgoals-1)
        if homegoals == 0
	   if rand(1000) > 800
	     homegoals = 1
           end	
        end
      end
    end

    return "#{homegoals}:#{gastgoals}"

  end

  def findTeamById(id)

    (0..@teams.length-1).each do |i|
      if teams[i].id == id
        return teams[i]
      end
    end

  end

end
