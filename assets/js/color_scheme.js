const SELECTORS = {
  toggler: "#dark-mode-toggler",
  darkIcon: "[data-icon='dark']",
  lightIcon: "[data-icon='light']",
  autoIcon: "[data-icon='auto']"
};

const TOGGLE_STATES = {
  AUTO: "auto",
  LIGHT: "light",
  DARK: "dark"
};

let darkModeTogglerEl;
let darkIcon;
let lightIcon;
let autoIcon;

let systemColorScheme;
let toggleState = 0;
const toggleOptions = [TOGGLE_STATES.AUTO, TOGGLE_STATES.LIGHT, TOGGLE_STATES.DARK];

export function init() {
  cacheElements();
  initializeSystemColorScheme();
  setInitialIconState();
  addEventListeners();
}

function cacheElements() {
  darkModeTogglerEl = document.querySelector(SELECTORS.toggler);
  darkIcon = darkModeTogglerEl.querySelector(SELECTORS.darkIcon);
  lightIcon = darkModeTogglerEl.querySelector(SELECTORS.lightIcon);
  autoIcon = darkModeTogglerEl.querySelector(SELECTORS.autoIcon);
}

function initializeSystemColorScheme() {
  if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
    systemColorScheme = TOGGLE_STATES.DARK;
    turnOnDarkMode();
  } else {
    systemColorScheme = TOGGLE_STATES.LIGHT;
    turnOffDarkMode();
  }
}

function setInitialIconState() {
  if (systemColorScheme === TOGGLE_STATES.DARK) {
    setIconToDark();
  } else {
    setIconToLight();
  }
  showAutoIcon();
}

function addEventListeners() {
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', handleSystemColorSchemeChange);
  darkModeTogglerEl.addEventListener("click", handleToggleClick);
}

function handleSystemColorSchemeChange(event) {
  systemColorScheme = event.matches ? TOGGLE_STATES.DARK : TOGGLE_STATES.LIGHT;
  if (isAutoMode()) {
    updateDocumentMode(systemColorScheme);
  }
}

function handleToggleClick() {
  toggleState = incrementToggleState();
  const toggleOption = toggleOptions[toggleState];

  updateIcons(toggleOption);
  updateDocumentMode(toggleOption);
}

function updateIcons(toggleOption) {
  if (toggleOption === TOGGLE_STATES.AUTO) {
    showAutoIcon();
  } else {
    removeAutoIcon();
  }

  if (toggleOption === TOGGLE_STATES.DARK) {
    setIconToDark();
  } else if (toggleOption === TOGGLE_STATES.LIGHT) {
    setIconToLight();
  }
}

function updateDocumentMode(mode) {
  if (mode === TOGGLE_STATES.DARK || (mode === TOGGLE_STATES.AUTO && systemColorScheme === TOGGLE_STATES.DARK)) {
    turnOnDarkMode();
  } else {
    turnOffDarkMode();
  }
}

function turnOnDarkMode() {
  document.documentElement.classList.add("dark");
}

function turnOffDarkMode() {
  document.documentElement.classList.remove("dark");
}

function setIconToDark() {
  darkIcon.classList.remove("hidden");
  lightIcon.classList.add("hidden");
}

function setIconToLight() {
  darkIcon.classList.add("hidden");
  lightIcon.classList.remove("hidden");
}

function showAutoIcon() {
  autoIcon.classList.remove("hidden");
}

function removeAutoIcon() {
  autoIcon.classList.add("hidden");
}

function incrementToggleState() {
  return (toggleState + 1) % toggleOptions.length;
}

function isAutoMode() {
  return toggleOptions[toggleState] === TOGGLE_STATES.AUTO;
}
