# Coding Style Rules

These rules apply to all code in this project. Keeping them here
instead of CLAUDE.md prevents manifest bloat while maintaining
enforcement. Claude discovers these recursively.

## Immutability
Always create new objects. Never mutate existing ones.

## File Organization
Many small files over few large files. 200-400 lines typical, 800 max.

## Error Handling
Handle errors explicitly at every level. Never silently swallow errors.
Provide user-friendly messages in UI code, detailed context server-side.

## Input Validation
Validate at system boundaries. Use schema-based validation where available.
Fail fast with clear error messages. Never trust external data.
