require 'time'

def read_file(file_name)

  output_status = {}
  times = []
  total = 0

  File.open(file_name) do |file|
    newer = false
    date_limit = Time.now.to_i - 24 * 60 * 60

    file.each_line do |line|
      newer ||= newer?(line, date_limit)
      up_status = get_up_status(line)

      #Выводит общее количество запросов с up_status > 200
      if newer && up_status > 200
        output_status[ up_status ] ||= 0
        output_status[ up_status ] += 1
      end

      #Выводит среднее время x_resp_time, которое уходит на ответ с up_status 200
      if up_status == 200
        times << get_x_resp_time(line)
      end
      total += 1
    end
  end
  avg_resp_time = times.inject(0){ |result, elem| result + elem } / times.size


  puts "#{output_status.values.inject(0){|result, elem| result + elem }} out of #{total} requests returned non 200 code in the past 24 hours:"
  output_status.each_pair {|key, value| puts "#{key} - #{value}"}
  puts "Average response with 200 code: #{avg_resp_time.round 2}" + " ms" + " from #{times.size} requests"
end

def newer?(log_line, date_limit)
  matcher = log_line.match(/\[(.+)\]/)
  date = matcher != nil && matcher[1] != nil && Time.strptime(matcher[1], '%d/%b/%Y:%T %z').to_i
  date != false && date_limit < date
end

def get_up_status(log_line)
  status = log_line.match(/up_status\="([0-9]*)"/)
  status[1].to_i
end

def get_x_resp_time(log_line)
  resp_data = log_line.match(/x_resp_time\="([0-9|.]*)ms"/)
  resp_data[1].to_f
end

read_file('nginx.txt')
