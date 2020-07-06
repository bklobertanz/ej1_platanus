
def generarVistaHTML(maximosPorMercado)

    fileName = 'index.html'
    fileHtml = File.new(fileName, "w+")
    fileHtml.puts "<!DOCTYPE html>"
    fileHtml.puts "<html lang='es'>"
    fileHtml.puts "<head>"
    fileHtml.puts "<title>Ejercicio Platanus</title>"
    fileHtml.puts "<meta charset='utf-8'>"
    fileHtml.puts "</head>"
    fileHtml.puts "<body>"
    fileHtml.puts "<p>Transacciones con el mayor monto, en las últimas 24 horas, por mercado</p>"
    fileHtml.puts "<table style='border: 1px solid black; border-collapse: collapse;'>"
    fileHtml.puts "<tr>"
    fileHtml.puts "<th style='border: 1px solid black'>Mercado</th>"
    fileHtml.puts "<th style='border: 1px solid black'>Monto mayor</th>"
    fileHtml.puts "</tr>"

    maximosPorMercado.each do |mercado, max|

        fileHtml.puts "<tr>"
        fileHtml.puts "<td style='border: 1px solid black;'>#{mercado}</td>"
        fileHtml.puts "<td style='border: 1px solid black;'>#{max}</td>"
        fileHtml.puts "</tr>"

    end 

    fileHtml.puts "</table>"
    fileHtml.puts "</body>"
    fileHtml.puts "</html>"
    fileHtml.close()

    system("xdg-open", "#{fileName}")

end 
# system("start #{fileName}") #...on windows
# system("open", "#{fileName}")  #macos