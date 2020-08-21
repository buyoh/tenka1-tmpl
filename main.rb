require 'net/https'

@host =  ENV['TK1_HOST'] || 'practice.gbc-2020.tenka1.klab.jp'
@token = ENV['TK1_TOKEN']

abort 'TK1_TOKEN is empty' unless @token

@solver_app = 'out/solver'

def exec_ai(game_id)
  rr, rw = IO.pipe
  wr, ww = IO.pipe

  pid = spawn(@solver_app, in: rr, out: ww)
  puts "ai start: pid=#{pid}"
  pclosed = false

  https = Net::HTTP.new(@host, 443)
  https.use_ssl = true
  https.start

  t1 = Thread.start do
    Process.waitpid pid
    pclosed = true
    rr.close
    ww.close
  end

  while line = wr.gets
    line.chomp!
    next if line.empty?

    url = line.gsub('$GAME$', game_id.to_s).gsub('$TOKEN$', @token)
    response = https.get('/api' + url)
    body = response.body
    code = response.code
    if code.to_i != 200
      puts "code is not ok: code=#{code}"
      break
    end
    rw.puts response.body
    rw.flush
  end

  unless pclosed
    Process.kill pid, :KILL
    t1.join
  end
  rw.close
  wr.close

  https.finish

  puts "ai exited: pid=#{pid}"
end

loop do
  responce = Net::HTTP.get_response(URI.parse("https://#{@host}/api/game"))
  body = responce.body
  game_id, timems = body.split.map(&:to_i)
  Thread.start(game_id) do |game_id|
    exec_ai game_id
  end
  sleep 0.001 * timems + 0.2
end
