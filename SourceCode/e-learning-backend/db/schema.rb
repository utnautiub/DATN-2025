# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_04_161613) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assignment_submissions", force: :cascade do |t|
    t.bigint "assignment_id"
    t.bigint "student_id"
    t.string "file_url"
    t.string "file_name"
    t.string "file_type"
    t.integer "file_size"
    t.datetime "submitted_at", precision: nil
    t.integer "score"
    t.text "feedback"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "teacher_id"
    t.string "title"
    t.text "description"
    t.datetime "deadline", precision: nil
    t.integer "max_points"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "attendance_records", force: :cascade do |t|
    t.bigint "session_id"
    t.bigint "student_id"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "timestamp", precision: nil
    t.string "method"
    t.boolean "is_valid"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "attendance_sessions", force: :cascade do |t|
    t.bigint "schedule_id"
    t.string "qr_code"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.integer "gps_range"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "buildings", force: :cascade do |t|
    t.bigint "school_id"
    t.string "name"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "chat_group_members", force: :cascade do |t|
    t.bigint "chat_group_id"
    t.bigint "user_id"
    t.datetime "joined_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "chat_groups", force: :cascade do |t|
    t.bigint "class_id"
    t.bigint "course_id"
    t.bigint "created_by"
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "chat_message_attachments", force: :cascade do |t|
    t.bigint "message_id"
    t.string "file_url"
    t.string "file_name"
    t.string "file_type"
    t.integer "file_size"
    t.datetime "uploaded_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "chat_messages", force: :cascade do |t|
    t.bigint "chat_group_id"
    t.bigint "user_id"
    t.text "content"
    t.datetime "sent_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "class_materials", force: :cascade do |t|
    t.bigint "class_id"
    t.bigint "course_id"
    t.bigint "teacher_id"
    t.string "title"
    t.text "description"
    t.string "material_type"
    t.string "file_url"
    t.string "file_name"
    t.string "file_type"
    t.integer "file_size"
    t.datetime "uploaded_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "classes", force: :cascade do |t|
    t.bigint "school_id"
    t.string "name"
    t.bigint "homeroom_teacher_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "school_id"
    t.bigint "subject_id"
    t.bigint "teacher_id"
    t.string "name"
    t.string "mode"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "departments", force: :cascade do |t|
    t.bigint "school_id"
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "course_id"
    t.datetime "enrolled_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "equipment_reports", force: :cascade do |t|
    t.bigint "equipment_id"
    t.bigint "user_id"
    t.text "description"
    t.string "status"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "exam_questions", force: :cascade do |t|
    t.bigint "exam_id"
    t.bigint "question_id"
    t.integer "order"
    t.integer "points"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "exam_room_streams", force: :cascade do |t|
    t.bigint "exam_room_id"
    t.bigint "student_id"
    t.string "stream_url"
    t.datetime "started_at", precision: nil
    t.datetime "ended_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "exam_rooms", force: :cascade do |t|
    t.bigint "exam_id"
    t.bigint "room_id"
    t.string "type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "exam_supervisors", force: :cascade do |t|
    t.bigint "exam_room_id"
    t.bigint "teacher_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "exams", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "teacher_id"
    t.string "exam_code"
    t.boolean "is_public"
    t.string "title"
    t.string "type"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.integer "duration"
    t.integer "total_points"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "forum_attachments", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "reply_id"
    t.string "file_url"
    t.string "file_name"
    t.string "file_type"
    t.integer "file_size"
    t.datetime "uploaded_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "forum_posts", force: :cascade do |t|
    t.bigint "forum_id"
    t.bigint "user_id"
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "forum_replies", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "user_id"
    t.text "content"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "forums", force: :cascade do |t|
    t.bigint "class_id"
    t.bigint "course_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "majors", force: :cascade do |t|
    t.bigint "department_id"
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "subject_id"
    t.bigint "teacher_id"
    t.boolean "is_public"
    t.string "type"
    t.text "content"
    t.jsonb "options"
    t.string "correct_answer"
    t.integer "points"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "room_equipments", force: :cascade do |t|
    t.bigint "room_id"
    t.string "name"
    t.string "status"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "building_id"
    t.string "name"
    t.integer "capacity"
    t.string "type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "class_id"
    t.string "day_of_week"
    t.time "start_time"
    t.time "end_time"
    t.bigint "room_id"
    t.string "meet_link"
    t.string "status"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "specializations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "students", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "class_id"
    t.bigint "major_id"
    t.bigint "program_id"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "subject_assignments", force: :cascade do |t|
    t.bigint "subject_id"
    t.bigint "teacher_id"
    t.bigint "school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.text "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "submission_answers", force: :cascade do |t|
    t.bigint "submission_id"
    t.bigint "question_id"
    t.text "answer"
    t.integer "score"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "exam_id"
    t.bigint "student_id"
    t.datetime "started_at", precision: nil
    t.datetime "submitted_at", precision: nil
    t.integer "score"
    t.text "feedback"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "teacher_specializations", force: :cascade do |t|
    t.bigint "teacher_id"
    t.bigint "specialization_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "teachers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "department_id"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "training_program_subjects", force: :cascade do |t|
    t.bigint "program_id"
    t.bigint "subject_id"
    t.integer "semester"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "training_programs", force: :cascade do |t|
    t.bigint "major_id"
    t.string "name"
    t.integer "start_year"
    t.integer "end_year"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "users", force: :cascade do |t|
    t.bigint "school_id"
    t.string "username"
    t.string "password"
    t.string "role"
    t.string "admin_level"
    t.string "google_access_token"
    t.string "google_refresh_token"
    t.datetime "google_token_expiry", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end
end
