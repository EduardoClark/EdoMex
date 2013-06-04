// This output binding handles statusOutputBindings
var justgageOutputBinding = new Shiny.OutputBinding();
$.extend(justgageOutputBinding, {
  find: function(scope) {
    return scope.find('.justgage_output');
  },
  renderValue: function(el, data) {
    if (!$(el).data('gauge')) {
      // If we haven't initialized this gauge yet, do it
      $(el).data('gauge', new JustGage({
        id: this.getId(el),
        value: 0,
        min: 0,
        max: 1000,
        title: "1er Cuatrimestre 2013",
        label: "APs Homicidio Doloso"
      }));
    }
    $(el).data('gauge').refresh(data);
  }
});
Shiny.outputBindings.register(justgageOutputBinding, 'dashboard.justgageOutputBinding');
