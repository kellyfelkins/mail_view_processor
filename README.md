# MailViewProcessor

Mail view files are files that combine html and text views together so that 
two views can be maintained together. 

Here's a simple partial that's used to generate a list of events, using links
in the html version with just text in the text version.

app/mail_views/mailman/_event.mail_view

    > html.haml
      %li
        = link_to("#{event.event_on.to_s(:micro)} #{event.subject}", message_url(event))
    > text.erb
      --- * <%= event.event_on.to_s(:micro) %> <%= event.subject %>
  
MailViewProcessor is a simple gem that provides a script that spits app/mail_view/*.mail_view files 
into appropriate app/view files. 

The example above would generate these files:

app/views/mailman/_event.html.haml

    -# AUTO GENERATED FILE / DO NOT EDIT (instead, edit /app/mail_views/_event.mail_view)
    %li
      = link_to("#{event.event_on.to_s(:micro)} #{event.subject}", message_url(event))

app/views/mailman/_event.text.erb

    <%# AUTO GENERATED FILE / DO NOT EDIT (instead, edit /app/mail_views/_event.mail_view) -%>
    --- * <%= event.event_on.to_s(:micro) %> <%= event.subject %>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mail_view_processor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mail_view_processor

## Usage

    $ mail_view_processor
    
## Development

There are no dependencies. Just check out the repo and make your changes.

I'm embarassed to say, but there are no tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kellyfelkins/mail_view_processor.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

