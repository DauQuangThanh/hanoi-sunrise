# UI Naming Convention Patterns

This document provides detailed UI naming patterns and examples for frontend projects.

## Component/Widget Naming Conventions

### Component Names Format
- **React/TypeScript**: PascalCase
  - Examples: `UserProfile.tsx`, `NavigationMenu.tsx`, `PaymentForm.tsx`
- **Vue**: kebab-case
  - Examples: `user-profile.vue`, `navigation-menu.vue`, `payment-form.vue`
- **Angular**: PascalCase with suffix
  - Examples: `UserProfileComponent`, `NavigationMenuComponent`

### Props/Attributes Naming
- Format: camelCase
- Examples:
  - `userName`, `userId`, `isVisible`, `isActive`
  - `onClick`, `onChange`, `onSubmit`
  - `maxLength`, `minValue`, `defaultValue`
- Boolean props: Use `is`, `has`, `should`, `can` prefixes
  - `isLoading`, `hasError`, `shouldShow`, `canEdit`

### Event Handler Naming
- Patterns: `handle*` or `on*`
- Examples:
  - `handleSubmit`, `handleClick`, `handleInputChange`
  - `onUserClick`, `onFormSubmit`, `onModalClose`
- Avoid: Generic names like `handle`, `onClick1`, `handler`

### State Variable Naming
- Descriptive names with context
- Boolean states: Use prefixes
  - `isLoading`, `isError`, `hasPermission`, `canDelete`
- Data states: Descriptive nouns
  - `userData`, `orderList`, `formValues`, `selectedItems`
- Count states: Use `count` suffix
  - `userCount`, `itemCount`, `pageCount`

## CSS/Styling Naming Conventions

### BEM Methodology
```css
/* Block */
.user-profile { }

/* Element */
.user-profile__avatar { }
.user-profile__name { }
.user-profile__bio { }

/* Modifier */
.user-profile--premium { }
.user-profile__avatar--large { }
```

### Utility-First (Tailwind-style)
```html
<div class="flex items-center justify-between p-4 bg-blue-500 text-white">
```
- Use semantic utility classes
- Avoid: custom classes when utilities exist

### Semantic CSS
```css
.header-navigation { }
.primary-button { }
.error-message { }
.content-wrapper { }
```

### CSS-in-JS Naming
```typescript
// styled-components
const UserCard = styled.div`...`;
const Avatar = styled.img`...`;

// emotion
const buttonStyles = css`...`;
```

### Style File Naming
- CSS Modules: `ComponentName.module.css`
- Styled Components: `ComponentName.styles.ts`
- SCSS: `component-name.scss`

## File Naming for UI Components

### React/TypeScript
```
src/components/
  UserProfile/
    UserProfile.tsx          # Component
    UserProfile.styles.ts    # Styles
    UserProfile.test.tsx     # Tests
    UserProfile.stories.tsx  # Storybook
    index.ts                 # Barrel export
```

### Vue
```
src/components/
  UserProfile/
    user-profile.vue         # Component
    user-profile.spec.ts     # Tests
    index.ts                 # Export
```

### Angular
```
src/app/components/
  user-profile/
    user-profile.component.ts
    user-profile.component.html
    user-profile.component.scss
    user-profile.component.spec.ts
```

## Directory Structure for UI Code

### Feature-Based Structure
```
src/
  features/
    auth/
      components/
        LoginForm/
        SignupForm/
      hooks/
        useAuth.ts
      pages/
        LoginPage.tsx
    user/
      components/
        UserProfile/
        UserCard/
      hooks/
        useUser.ts
      pages/
        ProfilePage.tsx
```

### Layer-Based Structure
```
src/
  components/
    common/
      Button/
      Input/
    layout/
      Header/
      Footer/
    user/
      UserProfile/
      UserCard/
  pages/
    HomePage.tsx
    ProfilePage.tsx
  hooks/
    useAuth.ts
    useUser.ts
```

### Asset Organization
```
public/
  images/
    icons/
      user.svg
      settings.svg
    logos/
      logo.png
      logo-dark.png
  fonts/
    Inter-Regular.woff2
```

## Accessibility Naming Conventions

### ARIA Attributes
```html
<button 
  aria-label="Close dialog"
  aria-describedby="dialog-description"
  aria-expanded="false"
>
```

### Roles
```html
<nav role="navigation" aria-label="Main navigation">
<main role="main">
<aside role="complementary">
```

### Label Associations
```html
<label htmlFor="email">Email</label>
<input id="email" type="email" />
```

### Landmark Naming
```html
<nav aria-label="Primary">...</nav>
<main>...</main>
<aside aria-label="Related content">...</aside>
<footer>...</footer>
```

## Framework-Specific Conventions

### React
**Hooks**: Always prefix with `use`
```typescript
useUser()
useAuth()
useCounter()
useLocalStorage()
```

**Context**: Suffix with `Context`
```typescript
UserContext
ThemeContext
AuthContext
```

**Higher-Order Components**: Prefix with `with`
```typescript
withAuth(Component)
withLayout(Component)
withErrorBoundary(Component)
```

**Custom Hooks**: Descriptive verb + noun
```typescript
useFetchUser()
useDebounce()
useWindowSize()
useMediaQuery()
```

### Vue 3 Composition API
**Composables**: Prefix with `use`
```typescript
useCounter()
useUser()
useMouse()
useEventListener()
```

**Directives**: Prefix with `v-`
```typescript
v-focus
v-click-outside
v-tooltip
```

**Plugins**: Descriptive name
```typescript
myPlugin
routerPlugin
i18nPlugin
```

### Angular
**Services**: Suffix with `Service`
```typescript
UserService
AuthService
DataService
```

**Directives**: Suffix with `Directive`
```typescript
HighlightDirective
TooltipDirective
ClickOutsideDirective
```

**Pipes**: Suffix with `Pipe`
```typescript
DatePipe
CurrencyPipe
FilterPipe
```

**Guards**: Suffix with `Guard`
```typescript
AuthGuard
RoleGuard
```

### Native Mobile (iOS/Android)
**View Controllers (iOS)**:
```swift
UserProfileViewController
LoginViewController
SettingsViewController
```

**Activities (Android)**:
```kotlin
MainActivity
UserProfileActivity
LoginActivity
```

**Views**:
```swift
// iOS
UserProfileView
CustomButton

// Android
user_profile_view.xml
custom_button.xml
```

## Do's and Don'ts

### ✅ DO
```typescript
// Clear, descriptive component names
<UserProfile userId={123} />
<NavigationMenu items={menuItems} />
<PaymentForm onSubmit={handlePayment} />

// Meaningful CSS classes
.user-profile__avatar--large
.navigation-menu__item--active
.payment-form__submit-button

// Descriptive event handlers
handleUserSubmit()
onModalClose()
handleInputChange()

// Clear state variables
isLoading
userData
selectedItems
hasPermission
```

### ❌ DON'T
```typescript
// Cryptic abbreviations
<UP uid={123} />
<NavMnu items={items} />
<PmtFrm onSub={handle} />

// Unclear CSS classes
.UP-av-lg
.nm-i-act
.pf-sb

// Generic handlers
handle()
onClick1()
handler()

// Vague state names
data
thing
flag
state1
```

## Common Anti-Patterns to Avoid

1. **Generic Names**
   - ❌ `Component1`, `Component2`
   - ❌ `thing`, `data`, `item`
   - ❌ `temp`, `tmp`, `x`, `y`
   - ✅ `UserProfile`, `userData`, `selectedUser`

2. **Inconsistent Casing**
   - ❌ Mixing: `UserProfile`, `user-card`, `NAVIGATION_MENU`
   - ✅ Consistent: `UserProfile`, `UserCard`, `NavigationMenu`

3. **Missing Semantic Meaning**
   - ❌ `div1`, `container3`, `section2`
   - ✅ `userContainer`, `mainSection`, `headerWrapper`

4. **Non-Descriptive Event Handlers**
   - ❌ `handle`, `onClick1`, `func`
   - ✅ `handleUserClick`, `onFormSubmit`, `handleModalClose`

5. **Overly Abbreviated Names**
   - ❌ `usrPrf`, `navMnu`, `btnClck`
   - ✅ `userProfile`, `navigationMenu`, `buttonClick`

6. **Inconsistent Prop Naming**
   - ❌ Mixing: `user_id`, `userName`, `ISACTIVE`
   - ✅ Consistent: `userId`, `userName`, `isActive`

7. **Poor Boolean Naming**
   - ❌ `loading`, `error`, `visible`
   - ✅ `isLoading`, `hasError`, `isVisible`

8. **Generic CSS Classes**
   - ❌ `.wrapper`, `.container`, `.box`
   - ✅ `.user-profile-wrapper`, `.content-container`, `.info-box`
