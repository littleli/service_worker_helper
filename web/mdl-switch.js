!function(){"use strict";var e=function(e){this.element_=e,this.init()};window.MaterialSwitch=e,e.prototype.Constant_={TINY_TIMEOUT:.001},e.prototype.CssClasses_={INPUT:"mdl-switch__input",TRACK:"mdl-switch__track",THUMB:"mdl-switch__thumb",FOCUS_HELPER:"mdl-switch__focus-helper",RIPPLE_EFFECT:"mdl-js-ripple-effect",RIPPLE_IGNORE_EVENTS:"mdl-js-ripple-effect--ignore-events",RIPPLE_CONTAINER:"mdl-switch__ripple-container",RIPPLE_CENTER:"mdl-ripple--center",RIPPLE:"mdl-ripple",IS_FOCUSED:"is-focused",IS_DISABLED:"is-disabled",IS_CHECKED:"is-checked"},e.prototype.onChange_=function(){this.updateClasses_()},e.prototype.onFocus_=function(){this.element_.classList.add(this.CssClasses_.IS_FOCUSED)},e.prototype.onBlur_=function(){this.element_.classList.remove(this.CssClasses_.IS_FOCUSED)},e.prototype.onMouseUp_=function(){this.blur_()},e.prototype.updateClasses_=function(){this.checkDisabled(),this.checkToggleState()},e.prototype.blur_=function(){window.setTimeout(function(){this.inputElement_.blur()}.bind(this),this.Constant_.TINY_TIMEOUT)},e.prototype.checkDisabled=function(){this.inputElement_.disabled?this.element_.classList.add(this.CssClasses_.IS_DISABLED):this.element_.classList.remove(this.CssClasses_.IS_DISABLED)},e.prototype.checkDisabled=e.prototype.checkDisabled,e.prototype.checkToggleState=function(){this.inputElement_.checked?this.element_.classList.add(this.CssClasses_.IS_CHECKED):this.element_.classList.remove(this.CssClasses_.IS_CHECKED)},e.prototype.checkToggleState=e.prototype.checkToggleState,e.prototype.disable=function(){this.inputElement_.disabled=!0,this.updateClasses_()},e.prototype.disable=e.prototype.disable,e.prototype.enable=function(){this.inputElement_.disabled=!1,this.updateClasses_()},e.prototype.enable=e.prototype.enable,e.prototype.on=function(){this.inputElement_.checked=!0,this.updateClasses_()},e.prototype.on=e.prototype.on,e.prototype.off=function(){this.inputElement_.checked=!1,this.updateClasses_()},e.prototype.off=e.prototype.off,e.prototype.init=function(){if(this.element_){this.inputElement_=this.element_.querySelector("."+this.CssClasses_.INPUT);var e=document.createElement("div");e.classList.add(this.CssClasses_.TRACK);var t=document.createElement("div");t.classList.add(this.CssClasses_.THUMB);var s=document.createElement("span");if(s.classList.add(this.CssClasses_.FOCUS_HELPER),t.appendChild(s),this.element_.appendChild(e),this.element_.appendChild(t),this.boundMouseUpHandler=this.onMouseUp_.bind(this),this.element_.classList.contains(this.CssClasses_.RIPPLE_EFFECT)){this.element_.classList.add(this.CssClasses_.RIPPLE_IGNORE_EVENTS),this.rippleContainerElement_=document.createElement("span"),this.rippleContainerElement_.classList.add(this.CssClasses_.RIPPLE_CONTAINER),this.rippleContainerElement_.classList.add(this.CssClasses_.RIPPLE_EFFECT),this.rippleContainerElement_.classList.add(this.CssClasses_.RIPPLE_CENTER),this.rippleContainerElement_.addEventListener("mouseup",this.boundMouseUpHandler);var i=document.createElement("span");i.classList.add(this.CssClasses_.RIPPLE),this.rippleContainerElement_.appendChild(i),this.element_.appendChild(this.rippleContainerElement_)}this.boundChangeHandler=this.onChange_.bind(this),this.boundFocusHandler=this.onFocus_.bind(this),this.boundBlurHandler=this.onBlur_.bind(this),this.inputElement_.addEventListener("change",this.boundChangeHandler),this.inputElement_.addEventListener("focus",this.boundFocusHandler),this.inputElement_.addEventListener("blur",this.boundBlurHandler),this.element_.addEventListener("mouseup",this.boundMouseUpHandler),this.updateClasses_(),this.element_.classList.add("is-upgraded")}},e.prototype.mdlDowngrade_=function(){this.rippleContainerElement_&&this.rippleContainerElement_.removeEventListener("mouseup",this.boundMouseUpHandler),this.inputElement_.removeEventListener("change",this.boundChangeHandler),this.inputElement_.removeEventListener("focus",this.boundFocusHandler),this.inputElement_.removeEventListener("blur",this.boundBlurHandler),this.element_.removeEventListener("mouseup",this.boundMouseUpHandler)}}();