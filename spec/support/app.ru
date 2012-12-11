app = proc do |env|
  [
    200,
    {
      'Content-Type' => 'text/html',
      'Content-Length' => '2'
    },
    ['hi']
  ]
end

run app
