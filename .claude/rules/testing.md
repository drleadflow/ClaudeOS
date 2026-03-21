# Testing Rules

## Coverage Target
80% minimum. Unit + integration + E2E all required.

## TDD Workflow
1. Write test first (RED)
2. Run test — it should FAIL
3. Write minimal implementation (GREEN)
4. Run test — it should PASS
5. Refactor (IMPROVE)
6. Verify coverage

## Test Isolation
Tests must not depend on execution order or shared mutable state.
Each test sets up and tears down its own context.

## When to Run What
- Small change to one file: run focused tests for that file
- Cross-cutting change: run full suite
- Before any commit: run affected test suites
