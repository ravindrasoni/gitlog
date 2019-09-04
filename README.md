
# GitLog

Welcome to GitLog! GitLog is a tool to get meaningful insights and formatted log of the work you have done in a git repo. 
Since, nothing comes free of cost, you have to follow a few rules while writing your git commits and this tool serves you well.

## Idea
The idea came up while struggling with daily updates from the team over the standups. While the standup, many people just go through their git commits and try to see what they have worked on and try to recap that. But if someone has a large commit history, then the updates are a mess. So, to formalise this and create a defined structure for the updates, we came up with this.

Another story is with the timesheets. People forget to fill up their timesheets on regular basis and after 2-3 days they totally forget what they worked on. And again, they end up writing some messy updates in their timesheets as well

## Structure 

The commits are structured into following types. Every commit has to fall under one of these types.

| type |description  |
|--|--|
| ***feat*** | A new feature |
| ***fix*** | A bug or defect resolution |
| ***refactor*** |A code change that neither fixes a bug nor adds a feature  |
| ***test*** | Adding or modifying test scripts or settings |
| ***chore*** | Changes to the build process or auxiliary tools, adding libraries or changing project configuration settings |
| ***style*** |Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)  |
| ***perf*** | A code change that improves performance |
| ***docs*** | Changes to ReadMe or other documentation |

## Rules to write commits
Each commit message should therefore contain three components to clarify it's context:

1.  **Type:** The type classifies the _nature_ of the change being made(described above). It should always conform to one of the following types and be _lowercase_

2.  **Scope:** The scope classifies where the change is being made, it might describe a certain task, an object or even a set of files. This term should _include no spaces_, but can include other characters, including capital letters and/or slashes to indicate scope paths.
3.  **Subject:** The subject contains a short description of the modification that was made. It should always begin with a lowercase letter and does _not_ contain a period.

###### For optimal readability, it’s important that the overall commit message be kept as short as possible. As a general rule of thumb, aim for a 50 character limit, but consider 69 characters the hard limit. This is primarily because GitHub will truncate anything beyond 69 characters. Always write your subject in an imperative fashion, as if you were commanding someone. In other words, lines should start with “Fix,” “Add,” or “Change” instead of “Fixed,” “Added,” or “Changed.” So keep all verbs in the present tense.

### **Commit Message Format**

When writing a commit message, it’s important for us to maintain a consistent, predictable structure. This allows for easier scannability and searchability. Each message should contain a Type, Scope and Subject using the following syntax:

> ***type(Scope): subject description in all lowercase***

So, for example:
> ***feat(UsernameInput): add username text field with validation handling***

You can also choose to define your scope as a path to better organize topics:

> ***feat(onboarding/username): add username text field with validation handling***

It’s critical that this syntax is precisely followed. This allows us to list separately the different types of modifications that are included in the build, such as features, bug fixes, refactoring, project configuration changes, tests, or stylistic updates to code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitlog'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gitlog

## Usage
Usage is simple. Just `cd` to the git repo and do `gitlog my`
1. `gitlog my` - to get all the logs for today
2. `gitlog my -d yyyy-MM-dd` - to get all the logs for specified day


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ravindrasoni/gitlog. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GitLog project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[ravindrasoni]/gitlog/blob/master/CODE_OF_CONDUCT.md).
