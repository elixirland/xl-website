// TODO: Clean up and test this code

const ColorScheme = {
  SELECTORS: {
    toggler: "#dark-mode-toggler",
    darkIcon: "[data-icon='dark']",
    lightIcon: "[data-icon='light']",
    autoIcon: "[data-icon='auto']"
  },
  
  TOGGLE_STATES: {
    AUTO: "auto",
    LIGHT: "light",
    DARK: "dark"
  },
  
  darkModeTogglerEl: null,
  darkIcon: null,
  lightIcon: null,
  autoIcon: null,

  systemColorScheme: null,
  toggleStateIndex: 0,
  toggleOptions: [],

  init() {
    this.toggleOptions = [this.TOGGLE_STATES.AUTO, this.TOGGLE_STATES.LIGHT, this.TOGGLE_STATES.DARK];

    this.cacheElements();
    this.initializeSystemColorScheme();
    this.setInitialIconState();
    this.addEventListeners();
  },

  cacheElements() {
    this.darkModeTogglerEl = document.querySelector(this.SELECTORS.toggler);
    this.darkIcon = this.darkModeTogglerEl.querySelector(this.SELECTORS.darkIcon);
    this.lightIcon = this.darkModeTogglerEl.querySelector(this.SELECTORS.lightIcon);
    this.autoIcon = this.darkModeTogglerEl.querySelector(this.SELECTORS.autoIcon);
  },

  initializeSystemColorScheme() {
    if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
      this.systemColorScheme = this.TOGGLE_STATES.DARK;
    } else {
      this.systemColorScheme = this.TOGGLE_STATES.LIGHT;
    }

    const userPreference = localStorage.getItem("color-scheme");

    if (userPreference) {
      this.toggleStateIndex = this.toggleOptions.indexOf(userPreference);
    } else {
      this.toggleStateIndex = 0;
    }

    if (this.toggleStateIndex == 0 && this.systemColorScheme === this.TOGGLE_STATES.DARK) {
      this.turnOnDarkMode();
    } else if (this.toggleStateIndex == 0 && this.systemColorScheme === this.TOGGLE_STATES.LIGHT) {
      this.turnOffDarkMode();
    } else if (this.toggleStateIndex == 1) {
      this.turnOffDarkMode();
    } else if (this.toggleStateIndex == 2) {
      this.turnOnDarkMode();
    }
  },

  setInitialIconState() {
    if (this.toggleStateIndex == 0 && this.systemColorScheme === this.TOGGLE_STATES.DARK) {
      this.setIconToDark();
      this.showAutoIcon();
    } else if (this.toggleStateIndex == 0 && this.systemColorScheme === this.TOGGLE_STATES.LIGHT) {
      this.setIconToLight();
      this.showAutoIcon();  
    } else if (this.toggleStateIndex == 1) {
      this.setIconToLight();
      this.hideAutoIcon();
    } else if (this.toggleStateIndex == 2) {
      this.setIconToDark();
      this.hideAutoIcon();
    }
  },

  addEventListeners() {
    window.matchMedia('(prefers-color-scheme: dark)').onchange = () => this.handleSystemColorSchemeChange;
    this.darkModeTogglerEl.onclick = () => this.handleToggleClick();
  },

  handleSystemColorSchemeChange(event) {
    this.systemColorScheme = event.matches ? this.TOGGLE_STATES.DARK : this.TOGGLE_STATES.LIGHT;
    if (this.isAutoMode()) {
      this.updateDocumentMode(this.systemColorScheme);
    }
  },

  handleToggleClick() {
    this.toggleStateIndex = this.incrementToggleStateIndex();
    const toggleOption = this.toggleOptions[this.toggleStateIndex];

    this.updateIcons(toggleOption);
    this.updateDocumentMode(toggleOption);

    if (this.isAutoMode()) {
      localStorage.removeItem("color-scheme");
    } else {
      this.saveUserPreference(toggleOption);
    }
  },

  saveUserPreference(toggleOption) {
    localStorage.setItem("color-scheme", toggleOption);
  },

  updateIcons(toggleOption) {
    if (toggleOption === this.TOGGLE_STATES.AUTO) {
      this.showAutoIcon();
    } else {
      this.removeAutoIcon();
    }

    if (toggleOption === this.TOGGLE_STATES.DARK) {
      this.setIconToDark();
    } else if (toggleOption === this.TOGGLE_STATES.LIGHT) {
      this.setIconToLight();
    }
  },

  updateDocumentMode(mode) {
    if (mode === this.TOGGLE_STATES.DARK || (mode === this.TOGGLE_STATES.AUTO && this.systemColorScheme === this.TOGGLE_STATES.DARK)) {
      this.turnOnDarkMode();
    } else {
      this.turnOffDarkMode();
    }
  },

  turnOnDarkMode() {
    document.documentElement.classList.add("dark");
  },

  turnOffDarkMode() {
    document.documentElement.classList.remove("dark");
  },

  setIconToDark() {
    this.darkIcon.classList.remove("hidden");
    this.lightIcon.classList.add("hidden");
  },

  setIconToLight() {
    this.darkIcon.classList.add("hidden");
    this.lightIcon.classList.remove("hidden");
  },

  showAutoIcon() {
    this.autoIcon.classList.remove("hidden");
  },

  hideAutoIcon() {
    this.autoIcon.classList.add("hidden");
  },

  removeAutoIcon() {
    this.autoIcon.classList.add("hidden");
  },

  incrementToggleStateIndex() {
    return (this.toggleStateIndex + 1) % this.toggleOptions.length;
  },

  isAutoMode() {
    return this.toggleOptions[this.toggleStateIndex] === this.TOGGLE_STATES.AUTO;
  }
};

export default ColorScheme;
