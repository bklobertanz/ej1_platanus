require 'net/http'
require 'json'
require 'time'
require './vista.rb'
require 'date'

DAY = 86400
HOUR = 3600
MINUTE = 60

def getMarketsId() 
    
    res = Net::HTTP.get_response(URI('https://www.buda.com/api/v2/markets.json'))
    if (res.code == '200')
        markets = JSON.parse(res.body)['markets']
        return markets.map {|market| market['id']}
    end 
    return 'Error'
end 

def getEpochTimeMs()
    currentTime = (Time.now.to_f * 1000).floor
    pastTime = ((Time.now - DAY).to_f * 1000).floor
    return [currentTime, pastTime]
end 

def getTrades(marketId, timestamp, limit = 100)

    url = URI("https://www.buda.com/api/v2/markets/#{marketId}/trades?timestamp=#{timestamp}&limit=#{limit}")
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    if(response.code == "200")
        return JSON.parse(response.body)['trades']
    end 
    return 'Error'
end 

def getTimeStamps(entries)
    return entries.map {|entry| entry[0].to_i}
end 

def getNuevoCurrentTimeStamp(timestamps)
    return timestamps.max 
end 

def getNuevoOldestTimeStamp(currentTimeStamp)
    timenow = Time.strptime(currentTimeStamp.to_s,'%Q')
    return ((timenow - DAY).to_f * 1000).floor
end 

def existeTimeStamp?(timestamps,timestamp)
    return timestamps.include? timestamps.to_s
end 

arrMarketsId = getMarketsId()
if(arrMarketsId != 'Error')

    maximosPorMercado = Hash.new

    arrMarketsId.each do |market|

        encontrado = false
        maximos = []
        arrEpochTime = getEpochTimeMs()    
        currentTime = arrEpochTime[0]
        oldestTime = arrEpochTime[1]

        while (!encontrado) do
           
            trades = getTrades(market, currentTime) 

            if(trades != 'Error')

                tradesLastTimestamp = trades['last_timestamp'].to_i
                entries = trades['entries']
                transactions = []

                if(oldestTime <= tradesLastTimestamp)

                    entries.each do |entry| 

                        amount = entry[1].to_f
                        transactions << amount

                    end

                    transactions.uniq!
                    maximos << transactions.max
                    
                else          
                    entries.each do |entry| 

                        timestamp = entry[0].to_i
                        amount = entry[1].to_f

                        if(oldestTime <= timestamp)

                            transactions << amount

                        end 

                    end 
                    if(transactions.size != 0)

                        transactions.uniq!
                        maximos << transactions.max

                    end 

                    encontrado = true

                end 

            else 

                puts 'Error: request trades.'
                encontrado = true

            end 

            currentTime = tradesLastTimestamp

        end 
        if (maximos.size != 0)

            maximosPorMercado[market] = maximos.max

        else

            maximosPorMercado[market] = "No hubo transacciones dentro de las 24 horas"

        end 

    end 
    
    generarVistaHTML(maximosPorMercado)

else 
    puts 'Error: request mercados.'

end 