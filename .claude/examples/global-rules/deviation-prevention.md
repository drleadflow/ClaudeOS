# Deviation Prevention — Stay On Target

## Core Principle
Every task has a GOAL. Every action must move toward that goal. If an action doesn't serve the goal, DON'T DO IT. Deviation is the #1 cause of wasted time and broken builds.

## The RALPH Loop (Review-Align-Lock-Progress-Halt)

Before EVERY significant action, run this mental loop:

### R — Review
- What is the original goal? (Re-read the task/plan)
- What have we done so far?
- What's the current state?

### A — Align
- Does my next action directly serve the goal?
- Am I adding scope that wasn't asked for? (STOP if yes)
- Am I solving a different problem than what was asked? (STOP if yes)
- Am I refactoring code I wasn't asked to touch? (STOP if yes)

### L — Lock
- Lock the scope: only touch what's needed for THIS goal
- Lock the files: only modify files relevant to THIS task
- Lock the approach: don't switch strategies mid-execution without re-planning

### P — Progress
- Execute the next step
- Mark progress (update task status)
- Verify the step succeeded before moving on

### H — Halt Check
- Did this step move us closer to the goal? (if not: STOP and reassess)
- Are we past 50% of expected effort with <25% of expected progress? (if yes: STOP and re-plan)
- Did something unexpected happen? (if yes: STOP and diagnose before continuing)
- Has the original goal changed? (if yes: STOP and confirm with the user)

## Deviation Red Flags (STOP immediately if you catch yourself doing any of these)

| Red Flag | What To Do Instead |
|----------|-------------------|
| "While I'm here, let me also..." | Don't. Finish the current task first. |
| "This would be better if I refactored..." | Only if asked. File it for later. |
| "Let me add error handling for edge case X" | Only at system boundaries. Don't anticipate phantom scenarios. |
| "I should update the docs too" | Only if explicitly asked or the docs are wrong about what you changed. |
| "Let me clean up this code I noticed" | No. Scope creep. Stay on task. |
| "This approach is wrong, let me start over" | Don't restart. Fix the specific issue. Starting over wastes everything done. |
| "Let me add a feature flag for this" | Just change the code. No speculative abstractions. |
| Touching files not related to the task | Stop. Check the goal. |
| 3+ failed attempts at the same fix | Stop. Re-plan. Don't retry blindly. |

## Worker Deviation Prevention
When running parallel agents (Manager-Worker pattern):

### Manager checks after each wave:
1. Did each worker stay within its assigned scope?
2. Did any worker modify files outside its scope?
3. Did any worker add features not in the plan?
4. Did the combined output move toward the goal?

### Worker self-check (built into every worker prompt):
- "Your ONLY job is [X]. Do not touch anything else."
- "If you encounter something outside your scope, REPORT it to Manager. Do not fix it."
- "When done, verify your changes only affect [specific files/areas]."

## Loop Protection for Autonomous Execution
When running multi-step autonomous tasks:

### Checkpoint every 3 steps:
1. Are we still solving the original problem?
2. Has scope expanded beyond what was planned?
3. Are we in a retry loop? (same error 3+ times = STOP)
4. Is cost/time proportional to progress?

### Hard stops:
- 5 consecutive failures → STOP, report to Manager/the user
- 30 minutes on a single subtask → STOP, reassess
- Files modified outside scope → STOP, revert, reassess
- Build broken and can't fix in 3 attempts → STOP, report

## Scope Lock Template
At the start of any task, explicitly state:
```
GOAL: [one sentence]
SCOPE: [files/areas I will touch]
OUT OF SCOPE: [things I will NOT do]
SUCCESS CRITERIA: [how I know I'm done]
```

This locks the scope. Anything outside SCOPE requires explicit approval.

## Cross-Service Deploy Rule
When changing an API contract (request/response shape, auth flow, endpoints):
- BOTH the API and all consumers must be updated and deployed TOGETHER
- Never deploy an API change without the frontend/client change in the same wave
- Test the full flow end-to-end before telling the user it's done
- Lesson learned: shipping API-side changes without the frontend counterpart causes user-facing errors
