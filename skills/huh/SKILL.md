---
name: huh
description: Re-pitch the last message when it did not land.
disable-model-invocation: true
---

The last message failed to land. Comprehension broke, so repair it.

Re-pitch what you just said. Decide how far back to go: what lost the user is usually wider than the final paragraph.

- Add the premise you skipped. A message lands when its "why now" arrives before its "how".
- Cut invented vocabulary. Every term the project has not agreed to is noise; reach for the ubiquitous language in `CONTEXT.md` instead, and plain words where no term exists.
- Shorter and clearer, never shorter and blunter. Deleting words without adding the missing premise repeats the failure in fewer characters.
- Do not apologise, do not narrate the correction, do not ask what confused them. Re-pitch and stop.

Repairing one message is not a fix for the next one. When the same term breaks comprehension twice, it belongs in `CONTEXT.md`: settle it through `drill`.
