ASPDM Guidelines (Non final version) ([AHK Lib](https://github.com/infogulch/AutoHotkey-StdLib/blob/master/README.md#ahk-lib-v2) v3)
==========

Outline
-------

- Must be centralized and secure so code can be trusted.
- But also must be easy to submit, and easy to accept submissions.
- Peer elected maintainers review submissions.
- Transparent processes are key.

Code Style Guidelines (Recommended)
---------------------

- Clean, well structured code.
- Code must be wrapped in functions/classes with clear, non-conflicting namespaces.
- Code must not depend on positioning of #include.
- Prefer code without side effects. (e.g. unnecessarily and unexpectedly polluting or relying on the global namespace.)
- Consistent indentation. (4 spaces per indentation?)
- Consistent brace style. ([Allman](http://en.wikipedia.org/wiki/Indent_style#Allman_style) / [K&R:1TBS](http://en.wikipedia.org/wiki/Indent_style#Variant:_1TBS))
- Exposed interfaces should be documented in a standard way. (doxygen or gendocs?).
- Exposed interfaces should be mostly stable and not change.
- Usage examples should be provided.
- Forum topic on [ahkscript.org](http://ahkscript.org/) <s>[AutoHotkey.com](http://www.autohotkey.com/)</s>. (keep the centralized support)

Submission
----------

- Any script can be submitted for review, <s>and must meet all requirements in the Code Style Guidelines section.</s>
- All scripts should <s>MUST</s> be submitted with a licence and it should <s>MUST</s> be included at the top of all files submitted.
- Group members will peer review the code for style and robustness.
- Script author is included in the process.
- Any issues found can be fixed and the script reevaluated.
- Two peer reviews to make sure any errors are caught early on.
- Eighty? percent majority approval for new scripts to be added into central repository.

Repository
----------

- Automatic download script(s).
- Autoupdate to the latest for the branch (<s>Basic?</s>, L, etc.).
- Separate branches for each version of AHK (<s>Basic?</s>, L, v2, etc.).
- Versions: (say a new version makes breaking changes) Separate files: SuperLib.ahk, SuperLib2.ahk; major versions only.
- Script author may commit short bug fixes with streamlined review process (only one review needed).

Maintainers
-----------

- (This might be easier with something like [gerrit](http://code.google.com/p/gerrit/), though more complicated.  Future maybe?)
- Maintainers should seek public opinion on key decisions whenever possible.