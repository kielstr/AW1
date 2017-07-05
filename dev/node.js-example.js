
const util = require('util')


var aw = {
  demo :  {
    otherLabels: []
  }
};

var otherLabels = aw.demo.otherLabels;

otherLabels.push('AcidWorx');
otherLabels.push('Trax');
otherLabels.push('AFF');
console.log(util.inspect(otherLabels, false, null))

var index = otherLabels.indexOf('AcidWorx');

if (index > -1) {
    otherLabels.splice(index, 1);
}

console.log(util.inspect(aw, false, null))
