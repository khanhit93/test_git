json.array!(@lessons) do |lesson|
  json.extract! lesson, :id, :name, :question
  json.url lesson_url(lesson, format: :json)
end
