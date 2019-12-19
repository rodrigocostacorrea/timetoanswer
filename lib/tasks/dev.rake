namespace :dev do

  DEFAULT_PASSWORD = 878787
  DEFAULT_EMAIL_URL = '@timetoanswer.com'
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Configure Development Environment"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Dropping DB") {%x(rails db:drop:_unsafe)}
      show_spinner("Creating DB") {%x(rails db:create)}
      show_spinner("Migrating DB") {%x(rails db:migrate)}
      show_spinner("Adding Default Admin") {%x(rails dev:add_default_admin)}
      show_spinner("Adding Fake Admins") {%x(rails dev:add_fake_admins)}
      show_spinner("Adding Default User") {%x(rails dev:add_default_user)}
      show_spinner("Adding Standard Subjects") {%x(rails dev:add_subjects)}
      show_spinner("Adding Questions and Answers") {%x(rails dev:add_questions_and_answers)}
    else
      puts "You are not on development environment!"
    end
  end

  desc "Adding default Admin"
  task add_default_admin: :environment do
    Admin.create!(
        email: "admin#{DEFAULT_EMAIL_URL}",
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adding Fake Admins"
  task add_fake_admins: :environment do
    30.times do
      Admin.create!(
          email: Faker::Internet.email,
          password: DEFAULT_PASSWORD,
          password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Adding default User"
  task add_default_user: :environment do
    User.create!(
        email: "user#{DEFAULT_EMAIL_URL}",
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adding Standard Subjects"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)
    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adding Questions and Answers"
  task add_questions_and_answers: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
        params = create_question_params subject
        answer_array = params[:question][:answers_attributes]

        add_answers answer_array
        elect_true_answer answer_array

        Question.create!(params[:question]
        )
      end
    end
  end

  desc "Reset Subject Count"
  task reset_subject_count: :environment do
    show_spinner("Reseting Subject Count...") do
      Subject.find_each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
    end
  end

  private

  def create_question_params subject = Subject.all.sample
    {question: {
        description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
        subject: subject,
        answers_attributes: []
    }
    }
  end

  def create_answer_params correct = false
    {description: Faker::Lorem.sentence, correct: correct}
  end

  def add_answers answer_array = []
    rand(2..5).times do |j|
      answer_array.push(create_answer_params)
    end
  end

  def elect_true_answer answer_array = []
    selected_index = rand(answer_array.size)
    answer_array[selected_index] = create_answer_params true
  end

  def show_spinner msg_start, msg_end = "Successful!"
    spinner = TTY::Spinner.new("[:spinner] #{msg_start} ...")
    spinner.auto_spin
    yield
    spinner.success("[ #{msg_end} ]")
  end

end
