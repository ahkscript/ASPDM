ASPDM Guidelines (Non final version) ([AHK Lib](https://github.com/infogulch/AutoHotkey-StdLib/blob/master/README.md#ahk-lib-v2) v3)
==========

Outline
-------

- There must be a default centralized and secure package repository at ahkscript.org that can be trusted.
- It must be easy to submit, and easy to accept submissions.
- (In case of moderation queue): Peer elected maintainers review submissions.
- Transparent processes are key.

Package Quality Guidelines
--------------------------

- Clean, well structured code.
- Code must be wrapped in functions/classes with clear, non-conflicting namespaces. Global variables should be avoided whenever possible.
- Code must not depend on positioning of #include.
- Prefer code without side effects. (e.g. unnecessarily and unexpectedly polluting or relying on the global namespace.)
- Code should be reasonably optimized.
- Consistent indentation style (Doesn't matter which).
- Consistent brace style (Doesn't matter which).
- Exposed interfaces are recommended to be documented in a standard way. (GenDocs or NDocs or ...?).
- The versioning must follow AutoHotkey-Flavored Semantic Versioning (see below).
- Exposed interfaces should be stable and not change (see Semantic Versioning below).
- Usage examples are encouraged to be provided.
- (Recommended) Forum topic at [ahkscript.org](http://ahkscript.org/)

AutoHotkey-Flavored Semantic Versioning
---------------------------------------

Given a version number MAJOR.MINOR.FEATURE.PATCH, increment the:

- MAJOR version when major breaking changes are made,
- MINOR version when minor breaking changes that do not affect a majority of users,
- FEATURE version when backwards-compatible (or breaking in rare cases) new features are added, and
- PATCH version when mere bug fixes are made. A release with a significant number of bug fixes can lead into a 'FEATURE' version bump.

Additional labels for pre-release and build metadata are available as extensions to the given format.

Pre-release/stable software version tag format: 0.BUILD[TAG]-PHASE

Submission
----------

- Any package can be submitted to the repository, and should meet all mandatory requirements in the Package Quality Guidelines section.
- All packages should be submitted with a license. Those submitted without a license are assumed to be released under the [ahkscript.org Default Package License](License.md).
- Package author is included in the package metadata.
- (In case of moderation queue):
  - Moderators will peer review the package for the above guidelines.
  - Package Metadata will be updated if need be (e.g. `isstdlib`).
  - Any issues found can be fixed and the package reevaluated.
  - Two peer reviews to make sure any errors are caught early on.
  - Eighty (?) percent majority approval for new packages to be added into ahkscript.org repository.

Repository
----------

- Automatic package download and installation.
- Autoupdate to the latest version.
- Separate sub-repositories for each set of AutoHotkey versions (v1.1, v2-alpha, AHK_H,  others ...).
- Versions: For each package the latest version of every major version will be stored, for compatibility purposes. (e.g. SomeLib-1, SomeLib-2...)

Users and moderators
--------------------

- The ahkscript.org repository account is the same as the forum account, and the same for moderators (?)
- Moderators should seek public opinion on key decisions whenever possible.
- Moderators must have a reasonable amount of experience with AutoHotkey.
- Moderators should be just and a dedicated team.
- ...more?
