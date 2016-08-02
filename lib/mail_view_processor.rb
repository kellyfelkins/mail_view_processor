require "mail_view_processor/version"

class MailViewProcessor
  def run
    project_full_dir = File.expand_path('.')
    mail_views_full_dir = File.join(project_full_dir, "/app/mail_views")
    views_full_dir = File.join(project_full_dir, "/app/views")

    Dir.new(mail_views_full_dir).each do |mailer_dir|
      next if mailer_dir =~ /^\.\.?$/

      puts "processing #{mailer_dir}"

      mail_view_mailer_full_dir = File.join(mail_views_full_dir, mailer_dir)

      view_mailer_full_dir = File.join(views_full_dir, mailer_dir)

      Dir.new(mail_view_mailer_full_dir).each do |mail_view_file_name|
        next if mail_view_file_name =~ /^\.\.?$/
        puts "  processing #{mail_view_file_name}"

        mail_view_full_file_name = File.join(mail_view_mailer_full_dir, mail_view_file_name)
        mail_view_relative_file_name = File.join('/app/mail_views', mail_view_file_name)
        output_file_data = {}
        File.open(mail_view_full_file_name, 'r') do |f|
          output_type = nil
          f.each_line do |line|
            puts "processing >#{line[0..30]}<"
            if line =~ /^> (.*)$/
              output_type = $1
              puts "handling #{output_type}"
              output_file_data[output_type] ||= []
              next
            end

            output_file_data[output_type] << (line.length > 1 ? line[2..-1] : line)
          end
        end

        base_view_file_name = mail_view_file_name[/^(.*)\.mail_view$/, 1]
        output_file_data.each do |output_type, lines|

          output_file_name = base_view_file_name + "." + output_type
          view_full_file = File.join(view_mailer_full_dir, output_file_name)
          puts "********* writing #{view_full_file}"
          FileUtils.mkdir_p(view_mailer_full_dir)
          FileUtils.rm_rf(view_full_file)
          File.open(view_full_file, "w") do |f|
            comment_for_type = comment_for(output_type, "AUTO GENERATED FILE / DO NOT EDIT (instead, edit #{mail_view_relative_file_name})")
            f << comment_for_type + "\n" if comment_for_type
            f << lines.join
          end
        end
      end
    end
  end

  def comment_for(output_type, text)
    case output_type
      when %r|\.haml$|
        "-# #{text}"
      when %r|\.erb$|
        "<%# #{text} -%>"
      when %r|^text$|
        nil
      else
        raise "unexpected output_type >#{output_type}<"
    end
  end
end
