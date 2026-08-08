---
name: teach
description: Teach the user a new skill or concept, within this workspace.
disable-model-invocation: true
argument-hint: "What would you like to learn about?"
---

The user has asked you to teach them something. This is a stateful request - they intend to learn the topic over multiple sessions.

## Teaching Workspace

Treat the current directory as a teaching workspace. The state of their learning is captured in this directory in several files:

- `MISSION.md`: A document capturing the _reason_ the user is interested in the topic. Use it to ground all teaching. Use the format in [MISSION-FORMAT.md](./MISSION-FORMAT.md).
- `./reference/*.html`: A directory of reference materials. These are the compressed learnings from the lessons - cheat sheets, reference algorithms, syntax, yoga poses, glossaries. They are the raw units of learning. Make them beautiful documents which print out well, designed for quick reference.
- `GLOSSARY.md`: The workspace's term glossary, at the workspace root. Use the format in [GLOSSARY-FORMAT.md](./GLOSSARY-FORMAT.md).
- `RESOURCES.md`: A list of resources which can be explored to ground your teaching in contextual knowledge, or to acquire knowledge and wisdom. Use the format in [RESOURCES-FORMAT.md](./RESOURCES-FORMAT.md).
- `./learning-records/*.md`: A directory of learning records, which capture what the user has learned. These are loosely equivalent to architectural decision records in software development - they capture non-obvious lessons and key insights that may need to be revised later, or drive future sessions. Use them to calculate the zone of proximal development. They are titled `0001-<dash-case-name>.md`, where the number increments each time. Use the format in [LEARNING-RECORD-FORMAT.md](./LEARNING-RECORD-FORMAT.md).
- `./lessons/*.html`: A directory of lessons. A **lesson** is a single, self-contained HTML output that teaches one tightly-scoped thing tied to the mission. This is the primary unit of teaching in this workspace.
- `./assets/*`: Reusable **components** shared across lessons. See [Assets](#assets).
- `NOTES.md`: A scratchpad for you to jot down user preferences, or working notes.

The learning theory every lesson is built on lives in [PEDAGOGY.md](./PEDAGOGY.md): knowledge/skills/wisdom, fluency vs storage strength, the difficulty dial, zone of proximal development, and feedback loops.

## Lessons

A lesson is the main thing you produce: the unit in which knowledge and skills reach the user. Each lesson is one self-contained HTML file, saved to `./lessons/` and titled `0001-<dash-case-name>.html` where the number increments each time.

Make each lesson **beautiful** (clean, readable typography and layout) since the user will return to these later to review. Think Tufte.

Keep the lesson short, and completable very quickly. Learners' working memory is very small, and we need to stay within it. But each lesson gives the user a single tangible win that they can build on. Keep it in the user's zone of proximal development.

If possible, open the lesson file for the user by running a CLI command.

Each lesson links via HTML anchors to other lessons and reference documents.

Each lesson recommends a primary source for the user to read or watch: the most high-quality, high-trust resource you found on the topic.

Each lesson contains a reminder to ask followup questions to the agent. The agent is their teacher, and can assist with anything that's unclear.

## Assets

Lessons are built from reusable **components**, stored in `./assets/`: stylesheets, quiz widgets, simulators, diagram helpers: anything a second lesson could reuse.

Reuse is the default, not the exception. Before authoring a lesson, read `./assets/` and build from the components already there. When a lesson needs something new and reusable, write it as a component in `./assets/` and link to it; never inline code a future lesson would duplicate.

A shared stylesheet is the first component every workspace earns: every lesson links it, so the lessons look like one consistent course rather than a pile of one-offs. As the workspace grows, so does the component library.

## The Mission

Tie every lesson into the mission - the reason that the user is interested in learning about the topic.

If the user is unclear about the mission, or the `MISSION.md` is not populated, your first job is to question the user on why they want to learn this.

Failing to understand the mission will mean knowledge acquisition is not grounded in real-world goals. Lessons will feel too abstract. You will have no way of judging what the user should do next.

Missions may change as the user develops more skills and knowledge. This is normal - make sure to update the `MISSION.md` and add a learning record to capture the change. Confirm with the user before changing the mission.

## Designing a lesson

Design each lesson around a single skill the user is going to learn, pitched into their zone of proximal development. Keep the knowledge in the lesson to only what that skill requires. Teach the knowledge first, then get the user to practice via an interactive feedback loop.

Gather knowledge first from trusted resources, tracked in `RESOURCES.md`. Litter lessons with citations - links to external resources to back up any claim made. This increases the trustworthiness of the lesson.

[PEDAGOGY.md](./PEDAGOGY.md) governs how hard to make each part, how to find the zone, and how to shape the feedback loop.

## Reference Documents

While creating lessons, also create reference documents. Lessons can reference these documents - they are useful for tracking raw units of knowledge useful across lessons.

Lessons will rarely be revisited later - reference documents will be. Make them the compressed essence of the lesson, in a format designed for quick reference.

Some learning topics lend themselves to reference:

- Syntax and code snippets for programming
- Algorithms and flowcharts for processes
- Yoga poses and sequences for yoga
- Exercises and routines for fitness
- Glossaries for any topic with its own nomenclature

Glossaries, in particular, are an essential reference. Once one is created, adhere to it in every lesson.

## `NOTES.md`

The user will sometimes express preferences of how they want to be taught, or things to keep in mind. This is the place to record those preferences, so you can refer back to them when designing lessons or working with the user.
