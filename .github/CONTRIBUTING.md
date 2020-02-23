# Contributing to Eclipse Station

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

These are just guidelines, not rules, use your best judgment and feel free to propose changes to this document in a pull request.

#### Table Of Contents

[What should I know before I get started?](#what-should-i-know-before-i-get-started)
  * [Code of Conduct](#code-of-conduct)

[How Can I Contribute?](#how-can-i-contribute)
  * [Your First Code Contribution](#your-first-code-contribution)
  * [Eclipse Station Coding Standards](#eclipse-station-coding-standards)
  * [Pull Requests](#pull-requests)
  * [Git Commit Messages](#git-commit-messages)

[Licensing](#Licensing)


## What should I know before I get started?

### Code of Conduct

This project adheres to the Contributor Covenant [code of conduct](code_of_conduct.md).
By participating, you are expected to uphold this code.

## How Can I Contribute?

### Your First Code Contribution

Unsure where to begin contributing to Eclipse Station? You can start by looking through the issues tab.

### Eclipse Station Coding Standards

Any code submissions that do not meet our coding standards are likely to be rejected, or at the very least, have a maintainer request changes on your PR. Save time and follow these standards from the start.

* If it is something like a bugfix that Polaris would want (the codebase we use), code it in their code and make the PR to them. We regularly update from them. They would want any general gameplay bugfixes, and things that are obviously intended to work one way, but do not. They do not have any of our fluff species (vulp, akula, fenn, etc) so do not make PRs related to that.
* Never edit stock Polaris .DMI files. If you are confused about which .DMI files we have added and which were there originally, refer to their repository and and see if they exist (https://github.com/PolarisSS13/Polaris). All PRs with edits to stock .DMI files will be rejected.
* When changing any code in any stock Polaris .DM file, you must mark your changes:
    * For single-line changes: //Eclipse Edit - "Explanation" (Edit can also be Add for new lines or Removal if you are commenting the line out)
    * For multi-line additions: //Eclipse Edit - "Explanation" and then at the bottom of your changes, //Eclipse Edit End
    * For multi-line removals: Use a block comment (/\* xxx \*/) to comment out the existing code block (do not modify whitespace more than necessary) and at the start, it should contain /\* Eclipse Removal - "Reason"
* Change whitespace as little as possible. Do not randomly add/remove whitespace.
* Any new files should be in modular eclipse folder, placed in sub-folders, corresponding to their content.
* Map changes must be in tgm format. See the [Mapmerge2 Readme] for details.

### Pull Requests

* Your submission must pass Travis CI checking. The checks are important, prevent many common mistakes, and even experienced coders get caught by it sometimes. If you think there is a bug in Travis, open an issue. (One known Travis issue is comments in the middle of multi-line lists, just don't do it)
* Your PR should not have an excessive number of commits unless it is a large project or includes many separate remote commits (such as a pull from Polaris). If you need to keep tweaking your PR to pass Travis or to satisfy a maintainer's requests and are making many commits, you should squash them in the end and update your PR accordingly so these commits don't clog up the history.
* You can create a WIP PR, and if so, please mark it with [WIP] in the title so it can be labeled appropriately. These can't sit forever, though.
* It is highly recommended to make an effort to keep your branch clean, ideally free from merge commits if possible. Keep in mind that everything you do will show up in Eclipse Station's history tree, and a branch that's too messy won't be merged. There are techniques to updating cleanly and multiple methods of cleaning up a messy history. You're encouraged to ask around if you don't know how.

### Git Commit Messages

* Limit the first line to 72 characters or less, otherwise it truncates the title with '...', wrapping the rest into the description.
* Reference issues and pull requests liberally.
* If your PR fixes an open issue, use one of the GitHub magic words: "Fixed/Fixes/Fix, Resolved/Resolves/Resolve, Closed/Closes/Close", as this will automatically close that issue when the PR is merged. For example, "Closes #1928".

## Licensing
Eclipse Station is licensed under the GNU Affero General Public License version 3, which can be found in full in LICENSE-AGPL3.txt.

Commits with a git authorship date prior to `1420675200 +0000` (2015/01/08 00:00) are licensed under the GNU General Public License version 3, which can be found in full in LICENSE-GPL3.txt.

All commits whose authorship dates are not prior to `1420675200 +0000` are assumed to be licensed under AGPL v3, if you wish to license under GPL v3 please make this clear in the commit message and any added files.

[Mapmerge2 Readme]: ../tools/mapmerge2/readme.md
