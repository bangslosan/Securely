var _isAndroid = (Ti.Platform.osname === 'android');

var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var securely = require('bencoding.securely');
Ti.API.info("module is => " + securely);

Ti.API.info("The properties object contains a secure version of the Ti.App.Properties API");

//You can provide optional identifier, if none provided we use your bundle id
var properties = securely.createProperties({
	identifier:"Foo",
	accessGroup:"Bar",
	secret:"sshh_dont_tell"
});

Ti.API.info("On Android you can also set your secret this way");
Ti.API.info("If called on iOS it wont do anything, but it wont error either");
properties.setSecret("it_is_a_secret");

function onChange(e){
	Ti.API.info("Property " + e.source + " had an action of type " + e.actionType);
};

function objectComparer(result,expected){
	var sourceResult = JSON.stringify(result);
	var expectedResult = JSON.stringify(expected);
	
	return resultHelper(sourceResult, expectedResult);	
};
function resultHelper(result, expected) {
			
	if (result instanceof Array) {
		var sourceResult = JSON.stringify(result);
		var expectedResult = JSON.stringify(expected);
		
		return resultHelper(sourceResult, expectedResult);
	} 
	
	if (result == expected) {
		return "Test Success ("+result+"=="+expected+")";
	} else {
		return "Test Failure: result (" + result + ") != expected (" + expected + ")";
	}
};


var l = Titanium.UI.createLabel({
	text:'See Log for output',
	height:'auto',
	width:'auto'
});
win.add(l);

var array = [
	{name:'Name 1', address:'1 Main St'},
	{name:'Name 2', address:'2 Main St'},
	{name:'Name 3', address:'3 Main St'},
	{name:'Name 4', address:'4 Main St'}	
];

//
// Test Default handling
//

//Valid DefaultsTitanium.API.info('Bool: ' + resultHelper(properties.getBool('whatever',true),true));
Titanium.API.info('Double: ' + resultHelper(properties.getDouble('whatever',2.5),2.5));
Titanium.API.info('int: ' + resultHelper(properties.getInt('whatever',1),1));
Titanium.API.info('String: ' + resultHelper(properties.getString('whatever',"Fred"),"Fred"));

// First StringList Test
var defaultString = new Array("testOne","testTwo");

Titanium.API.info('StringList-1: ' + resultHelper(properties.getList('whatever',defaultString),defaultString));
// Second StringList Test
defaultString = new Array();
Titanium.API.info('StringList-2: ' + resultHelper(properties.getList('whatever',defaultString),defaultString));


if(_isAndroid){
	//On Android defaults are different
	//No Defaults
	Titanium.API.info('Bool: ' + resultHelper(properties.getBool('whatever'),false));
	Titanium.API.info('Double: ' + resultHelper(properties.getDouble('whatever'),0));
	Titanium.API.info('int: ' + resultHelper(properties.getInt('whatever'),0));
	Titanium.API.info('String: ' + resultHelper(properties.getString('whatever'),null));
	
	Titanium.API.debug('StringList: ' + resultHelper(properties.getList('whatever'),null));	
}else{
	//No Defaults
	Titanium.API.info('Bool: ' + resultHelper(properties.getBool('whatever'),null));
	Titanium.API.info('Double: ' + resultHelper(properties.getDouble('whatever'),null));
	Titanium.API.info('int: ' + resultHelper(properties.getInt('whatever'),null));
	Titanium.API.info('String: ' + resultHelper(properties.getString('whatever'),null));
	
	Titanium.API.debug('StringList: ' + resultHelper(properties.getList('whatever'),null));	
}


//
// Round-trip tests
//
//
// test setters
//
properties.setString('String','I am a String Value ');
properties.setInt('Int',10);
properties.setBool('Bool',true);
properties.setDouble('Double',10.6);
properties.setList('MyList',array);

//
// test getters
//

Titanium.API.info('String: '+ properties.getString('String'));
Titanium.API.info('Int: '+ properties.getString('Int'));
Titanium.API.info('Bool: '+ properties.getString('Bool'));
Titanium.API.info('Double: '+ properties.getString('Double'));
Titanium.API.info('List:');


var list = properties.getList('MyList');
for (var i=0;i<list.length;i++)
{
	Titanium.API.info('row['+i+'].name=' + list[i].name + ' row['+i+'].address=' + list[i].address );
}


var allProperties = properties.listProperties();
Ti.API.info(JSON.stringify(allProperties));

properties.removeAllProperties();

allProperties = properties.listProperties();
Ti.API.info(JSON.stringify(allProperties));

//
// test out remove property and setting to null
//
properties.setString('String',null);
properties.removeProperty('Int');
Titanium.API.info("String should be null - value = " + resultHelper(properties.getString('String'),null));
Titanium.API.info("Int should be null - value = " + resultHelper(properties.getString('Int'),null));

//Remove our Change Event Handler
properties.removeEventListener('changed',onChange);

win.open();
