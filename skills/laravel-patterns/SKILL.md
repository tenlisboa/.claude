---
name: laravel-patterns
description: Laravel 12 best practices, Eloquent patterns, service classes, Form Requests, and PHP 8.x features. Use when working with Laravel projects, controllers, models, migrations, or any PHP backend code.
allowed-tools: Read, Grep, Glob, Bash
---

# Laravel Development Patterns

## Architecture Principles

### Service Layer Pattern

- Controllers should be thin (max 10 lines per method)
- Business logic lives in Service classes
- Use dependency injection via constructor

```php
// app/Services/UserService.php
class UserService
{
    public function __construct(
        private readonly UserRepository $users,
        private readonly NotificationService $notifications
    ) {}
}
```

### Repository Pattern (when needed)

- Use for complex queries or when switching ORMs is possible
- Keep Eloquent in repositories, not controllers
- Return Collections or Models, never arrays

## Eloquent Best Practices

### Query Optimization

- Always use `select()` to limit columns
- Use `with()` for eager loading (prevent N+1)
- Use `withCount()` instead of loading relations just to count
- Prefer `chunk()` or `lazy()` for large datasets

```php
User::select(['id', 'name', 'email'])
    ->with(['posts:id,user_id,title'])
    ->withCount('comments')
    ->where('active', true)
    ->lazy();
```

### Relationships

- Define inverse relationships
- Use `belongsToMany` with pivot timestamps
- Prefer `hasOneThrough` / `hasManyThrough` over nested queries

### Scopes

- Use local scopes for reusable query logic
- Name scopes as adjectives: `scopeActive`, `scopeRecent`

## Controllers

### Resource Controllers

- Use `php artisan make:controller -r` for CRUD
- Follow REST conventions strictly
- Return proper HTTP status codes

### Form Requests

- Always use Form Requests for validation
- Put authorization logic in `authorize()` method
- Use custom messages and attributes

```php
class StoreUserRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('create', User::class);
    }

    public function rules(): array
    {
        return [
            'email' => ['required', 'email', 'unique:users'],
            'password' => ['required', Password::defaults()],
        ];
    }
}
```

## Testing with Pest

### Structure

```php
describe('UserService', function () {
    beforeEach(fn () => $this->service = app(UserService::class));

    it('creates user with valid data', function () {
        $user = $this->service->create([...]);
        expect($user)->toBeInstanceOf(User::class);
    });

    it('throws exception for duplicate email')
        ->throws(DuplicateEmailException::class);
});
```

### Database Testing

- Use `RefreshDatabase` trait
- Use factories with states
- Test relationships with `assertDatabaseHas`

## Migrations

### Naming Convention

- `create_users_table` for new tables
- `add_status_to_orders_table` for adding columns
- `drop_legacy_users_table` for removals

### Best Practices

- Always add `down()` method
- Use `foreignId()->constrained()` for foreign keys
- Add indexes on columns used in WHERE/ORDER BY

## Security Checklist

- [ ] Use `$fillable` or `$guarded` on models
- [ ] Sanitize user input with Form Requests
- [ ] Use policies for authorization
- [ ] Hash passwords with `Hash::make()`
- [ ] Use `signed` URLs for sensitive actions
- [ ] Enable CSRF protection
- [ ] Use `encrypt()` for sensitive data

## Performance

- Use Redis for cache and sessions
- Queue heavy operations (emails, exports)
- Use `php artisan optimize` in production
- Enable OPcache
- Use database indexes strategically
