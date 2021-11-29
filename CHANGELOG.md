# CHANGELOG
All notable changes to this project will be documented in this file.

## 2.2.2 - 2021-11-29
### Added
- Docs for services
  - Auth
  - Storage
  - OneSignal
  - Translations
### Changed
- State logic from services to controllers
- `PathProvider` for `Hive`
- Deprecated Splash screen implementation
### Fixed
- Questionnaire page update on answer sent
- Missing translations:
  - "Saldo actual" on ledger
  - ContractType translations on profile

## 2.2.1 - 2021-11-16
- Make public the [UMMobile project](https://github.com/UMMobile) 🎉
### Added
- Employee ledger 🎉
- Block app when there is an update 🎉
- Exit story on slide down 🎉
### Changed
- Improve design for ledger 🎉
- Centralized offline state management
- New internal project structure
- Separate `/api` to a package: `ummobile_sdk`
- Change from `Stateful` to `Stateless` widgets
- Use user token for production services
- Rename fetches methods on controllers to a stadarized form
### Fixed
- Refresh session instead of closing 🎉

## 2.2.0 - 2021-10-17
### Added
- Source of the questionnaire symptoms
- Conéctate stories 🎉
### Changed
- Loading design
- Validation for COVID questionnaire
  - Validates if more than 7 days have not passed since suspect start date
  - Validates if had recent contact and mark it as suspect

## 2.1.2 - 2021-09-03
### Added
- Multiple questionnaires (multiple users) 🎉
- App configuration 🎉
  - Theme
  - Language
- "Carta responsiva" validation for COVID questionnaire
### Changed
- Separate appbar title theme from rest of text styles
- Validations for COVID questionnaire
  - If have COVD + have Quarantine + have Quarantine end date + quarantine end date is over = can answer
### Fixed
- `UTF-8` errors

## 2.1.1 - 2021-08-23
### Added
- Conéctate blog 🎉
- Alert to delete notifications 🎉
- Employee photos service 🎉
- Reload to almost all pages 🎉
- Employees calendar 🎉
- Button to navigate to login fields instead
- CHANGELOG
- ROADMAP
### Removed 
- Remove add another user button
### Changed
- Merges students calendars into only one
- Update validations for COVID questionnaire
   - If you have symptoms you will be automatically marked as suspect
### Fixed
- Fixes design for calendar events description
- Fixes translations for alerts
- Fixes errors for students that start with zero
- Fixes notifications list update

## 2.1.0 - 2021-08-10
### Added
- Institutional agenda 🎉
  - Institutional agenda
  - "Legados"
- Quick logins 🎉
- Roles support 🎉
- Employee stuff 🎉
  - General info
- English translation 🎉
- Drawer 🎉
- Up-right icons (can have badges) 🎉
### Changed
- Refactor general design 🎉
  - Update main header 🎉
  - Update tabs order 🎉
- Reduce shadow for login box
- Update & improve health questionnaire
- Update to null safety packages
- Update OneSignal SDK

## 2.0.0 - 2021-06-14
Flutter initial version
### Added
- Add dark mode support
### Fixed
- Fix error with long title for notifications
