## fog-google 2.0 -> 3.0:

### SQL:
- `Fog::Google::SQL::Instance` resources are created synchronously by default. 
You can override it with `Fog::Google::SQL::Instance.create(true)`

- `Fog::Google::SQL::Instance.destroy` - `async:` named parameter has been replaced with `async` positional parameter.
You should now call `Fog::Google::SQL::Instance.destroy(false)` to disable async flag, as with other Fog::Google models.

- `Fog::Google::SQL::User.destroy` - `async:` named parameter has been replaced with `async` positional parameter.
  You should now call `Fog::Google::SQL::User.destroy(false)` to disable async flag, as with other Fog::Google models.
