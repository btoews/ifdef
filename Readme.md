# Ifdef

Ifdef parses Ruby files, removing conditional branches that will never execute. You provide a set of statements that are known to be true or false (Eg. `Rails.production?` will be `true` in production), and Ifdef uses that to decide which branches will run and which to delete.

## Usage

```
Usage: ifdef [options] file
-a, --true=MANDATORY             A comma separated list of statements to treat as true
-b, --false=MANDATORY            A comma separated list of statements to treat as false
-c, --config=MANDATORY           The path to a JSON truth config file
-h, --help                       Show this message
```

### Example

```
ifdef -a "Rails.production?" -b "Rails.test?" ./app/controllers/application_controller.rb
```

## Installing

- `gem install ifdef`
