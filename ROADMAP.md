# ROADMAP
_**Changes & release dates in versions further from the next release are more likely to change.**_

## 2.3.0 - 2022-?-?
### Adds
- Guide / tutorial on first install π
  - How to sign up
  - How to delete notifications
  - How to pay
- Features for employees: π
  - Vacations & work permissions
  - CFDI π
- Warning if user doesn't exist
### Change
- (**Opt**) Separate theme and global componentes (like form)
- (**Opt**) Save to local the notifications to be able to show them without connection
  - Note: If is read without connection a problem can happen
### Fixes
- Notifications are not marked as received on arrival
  - Because that code should be written in native code... F

## 2.2.3 - 2021-12-10 β
### Adds
- (**Opt**) Student docs π
### Change
- Shimmer effect for ledger
- Force only minor and major versions updates
- OneSignal package version
### Fixes
- Invert order for movements in the same day for employees ledger at least
- Not entering to the app if no internet connection
  
## 2.2.2 - 2021-11-29 β
### Adds
- Docs for services
  - Auth
  - Storage
  - OneSignal
  - Translations
### Change
- State logic from services to controllers
- `PathProvider` for `Hive`
- Deprecated Splash screen implementation
### Fixes
- Questionnaire page update on answer sent
- Missing translations:
  - "Saldo actual" on ledger
  - ContractType translations on profile

## 2.2.1 - 2021-11-16 β
- Make public the [UMMobile project](https://github.com/UMMobile) π
### Adds
- Employee ledger π
- Block app when there is an update π
- Exit story on slide down π
### Change
- Improve design for ledger π
- Centralized offline state management
- New internal project structure
- Separate `/api` to a package: `ummobile_sdk`
- Change from `Stateful` to `Stateless` widgets
- Use user token for production services
- Rename fetches methods on controllers to a stadarized form
### Fixes
- Refresh session instead of closing π

## 2.2.0 - 2021-10-17 β
### Adds
- ConΓ©ctate stories π
### Change
- Loading design
- Validation for COVID questionnaire
  - Validates if more than 7 days have not passed since suspect start date
  - Validates if had recent contact and mark it as suspect

## 2.1.2 - 2021-09-03 β
### Adds
- Multiple questionnaires (multiple users) π
- App configuration π
  - Theme
  - Language
- "Carta responsiva" validation for COVID questionnaire
### Change
- Separate appbar title theme from rest of text styles
- Validations for COVID questionnaire
  - If have COVD + have Quarantine + have Quarantine end date + quarantine end date is over = can answer
### Fixes
- `UTF-8` errors

## 2.1.1 - 2021-08-23 β
### Adds
- ConΓ©ctate blog π
- Alert to delete notifications π
- Employee photos service π
- Reload to almost all pages π
- Employees calendar π
- Button to navigate to login fields instead
- CHANGELOG
- ROADMAP
### Remove
- Remove add another user button
### Change
- Merges students calendars into only one
- Update validations for COVID questionnaire
   - If you have symptoms you will be automatically marked as suspect
### Fixes
- Fixes design for calendar events description
- Fixes translations for alerts
- Fixes errors for students that start with zero
- Fixes notifications list update

## 2.1.0 - 2021-08-10 β
### Adds
- Institutional agenda π
  - Institutional agenda
  - "Legados"
- Quick logins π
- Roles support π
- Employee stuff π
  - General info
- English translation π
- Drawer π
- Up-right icons (can have badges) π
### Change
- Refactor general design π
  - Update main header π
  - Update tabs order π
- Reduce shadow for login box
- Update and improve health questionnaire
- Update to null safety packages
- Update OneSignal SDK

## 2.0.0 - 2021-06-14 β
Flutter initial version.
### Adds
- Add dark mode support
### Fixes
- Fix error with long title for notifications on notifications list