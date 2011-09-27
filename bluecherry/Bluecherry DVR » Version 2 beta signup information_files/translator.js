olark.declare({name:"Translator",version:"1.0",startup:function(f){var n={af:"Afrikaans",sq:"Albanian",am:"Amharic",ar:"Arabic",hy:"Armenian",az:"Azerbaijani",eu:"Basque",be:"Belarusian",bn:"Bengali",bh:"Bihari",bg:"Bulgarian",my:"Burmese",ca:"Catalan",chr:"Cherokee",zh:"Chinese","zh-CN":"Chinese Simplified","zh-TW":"Chinese Traditional",hr:"Croatian",cs:"Czech",da:"Danish",dv:"Dhivehi",nl:"Dutch",en:"English",eo:"Esperanto",et:"Estonian",tl:"Filipino",fi:"Finnish",fr:"French",gl:"Galician",ka:"Georgian",
de:"German",el:"Greek",gn:"Guarani",gu:"Gujarati",iw:"Hebrew",hi:"Hindi",hu:"Hungarian",is:"Icelandic",id:"Indonesian",iu:"Inuktitut",ga:"Irish",it:"Italian",ja:"Japanese",kn:"Kannada",kk:"Kazakh",km:"Khmer",ko:"Korean",ku:"Kurdish",ky:"Kyrgyz",lo:"Laothian",lv:"Latvian",lt:"Lithuanian",mk:"Macedonian",ms:"Malay",ml:"Malayalam",mt:"Maltese",mr:"Marathi",mn:"Mongolian",ne:"Nepali",no:"Norwegian",or:"Oriya",ps:"Pashto",fa:"Persian",pl:"Polish","pt-PT":"Portuguese",pa:"Punjabi",ro:"Romanian",ru:"Russian",
sa:"Sanskrit",sr:"Serbian",sd:"Sindhi",si:"Sinhalese",sk:"Slovak",sl:"Slovenian",es:"Spanish",sw:"Swahili",sv:"Swedish",tg:"Tajik",ta:"Tamil",tl:"Tagalog",te:"Telugu",th:"Thai",bo:"Tibetan",tr:"Turkish",uk:"Ukrainian",ur:"Urdu",uz:"Uzbek",ug:"Uighur",vi:"Vietnamese",cy:"Welsh",yi:"Yiddish"},o=function(c,a){var d=c.text;f.logger.debug("[Translator] detecting language for '"+d+"'");f.__SPI_remote.requestJson({url:"http://ajax.googleapis.com/ajax/services/language/detect",params:{v:"1.0",q:d}},function(b){b.responseData&&
b.responseData.language&&b.responseData.language.length>0?a({language:b.responseData.language,confidence:b.responseData.confidence}):a({language:null,confidence:0})})},h=function(c,a){var d=c.text,b=c.fromLanguage,e=c.toLanguage;e==b?a({translatedText:d}):(f.logger.debug("[Translator] using Google Language API to translate '"+d+"' from",b,"to",e),f.__SPI_remote.requestJson({url:"http://ajax.googleapis.com/ajax/services/language/translate",params:{v:"1.0",q:d,langpair:b+"|"+e}},function(b){b.responseData&&
b.responseData.translatedText?a({translatedText:b.responseData.translatedText}):a({translatedText:d})}))},i=function(c){return n[c.toLowerCase()]||"{"+c.toUpperCase()+"}"},j=function(c){this.__state=f.data.getConversationObject({key:"speaker::"+c.name,initialValue:{recentDetectionResults:[],recentMessages:[]}});this.__defaultLanguage=c.defaultLanguage;this.__callbacksWaitingForDetection=[]};(function(c){c.getDetectedLanguage=function(a){var d=this.__state.get().recentDetectionResults;a&&this.__callbacksWaitingForDetection.push(a);
var b=d.length,e={},c=0,f=0;for(a=null;b--;){var g=d[b].language,l=d[b].confidence;e[g]=e[g]||0;e[g]++;e[g]>f?(f=e[g],a=g):l>c&&e[g]==f?(c=l,a=g):a||(a=g)}if(a){d=this.__callbacksWaitingForDetection;this.__callbacksWaitingForDetection=[];for(b=0;b<d.length;b++)d[b](a)}return a||this.__defaultLanguage};c.recordMessage=function(a){var d=this,b=a.text||a;d.__state.edit(function(a){if(a.recentMessages.length>=3)a.recentMessages=a.recentMessages.slice(1);a.recentMessages.push(b)});o({text:b},function(a){a.language&&
d.__state.edit(function(b){if(b.recentDetectionResults.length>=3)b.recentDetectionResults=b.recentDetectionResults.slice(1);b.recentDetectionResults.push(a)})})};c.getRecentMessageHistory=function(){return this.__state.get().recentMessages}})(j.prototype);var m=function(c){this.__visitorSpeaker=c.visitorSpeaker;this.__operatorSpeaker=c.operatorSpeaker;this.__state=f.data.getConversationObject({key:"translator",initialValue:{translationActive:!1,operatorLanguage:null,visitorLanguage:null}})};(function(c){c.startTranslating=
function(a){a=a||{};var d=this,b=a.operatorLanguage||d.__operatorSpeaker.getDetectedLanguage(),c=a.visitorLanguage||d.__visitorSpeaker.getDetectedLanguage();a=null;b!=c?(d.__state.edit(function(a){a.translationActive=!0;a.operatorLanguage=b;a.visitorLanguage=c}),a="translating from "+i(c)+" to "+i(b),d.translateFromEnglishForOperator({text:a},function(a){f.chat.sendNotificationToOperator(a.translatedText);var k=d.__visitorSpeaker.getRecentMessageHistory();h({text:k.join(" - "),fromLanguage:c,toLanguage:b},
function(a){var b="";a=a.translatedText.split(" - ");for(var c=0;c<k.length;)b+="\n>> "+k[c]+" ("+a[c]+")",c++;f.chat.sendNotificationToOperator({body:b})})})):(a="you are speaking the same language ("+i(b)+")",d.translateFromEnglishForOperator({text:a},function(a){f.chat.sendNotificationToOperator({body:a.translatedText})}))};c.stopTranslating=function(){this.__state.edit(function(a){a.translationActive=!1})};c.translateFromEnglishForOperator=function(a,c){var b=a.text,e=this.__state.get().operatorLanguage||
this.__operatorSpeaker.getDetectedLanguage();h({text:b,fromLanguage:"en",toLanguage:e},function(a){c({translatedText:a.translatedText})})};c.processMessageFromOperator=function(a,c){var b=a.text||a,e=this.__state.get();this.__operatorSpeaker.recordMessage({text:b});if(e.translationActive){var f=e.operatorLanguage||this.__operatorSpeaker.getDetectedLanguage();e=e.visitorLanguage||this.__visitorSpeaker.getDetectedLanguage();h({text:b,fromLanguage:f,toLanguage:e},function(a){c({translatedText:a.translatedText})})}else c({translatedText:b})};
c.processMessageFromVisitor=function(a,c){var b=a.text||a,e=this.__state.get();this.__visitorSpeaker.recordMessage({text:b});if(e.translationActive){var f=e.operatorLanguage||this.__operatorSpeaker.getDetectedLanguage();e=e.visitorLanguage||this.__visitorSpeaker.getDetectedLanguage();h({text:b,fromLanguage:e,toLanguage:f},function(a){c({translatedText:a.translatedText})})}else c({translatedText:b})}})(m.prototype);(function(){var c=new m({visitorSpeaker:new j({name:"visitor",defaultLanguage:"en"}),
operatorSpeaker:new j({name:"operator",defaultLanguage:"en"})});f.chat.onCommandFromOperator(function(a){a=a.command;switch(a.name){case "translate":a.body&&a.body.length?(a=a.body.replace(/\s+/,"").replace(/\s+/,""),c.startTranslating({visitorLanguage:a})):c.startTranslating();break;case "notranslate":c.stopTranslating()}});f.chat.onMessageToVisitor(function(a){a.message.__SPI_deferMessageDelivery(function(d){c.processMessageFromOperator({text:a.message.body},function(b){b.translatedText!=a.message.body&&
(a.message.updateBody(a.message.body+" ("+b.translatedText+")"),c.translateFromEnglishForOperator({text:"translated your message"},function(a){f.chat.sendNotificationToOperator({body:a.translatedText+": "+b.translatedText})}));d.deliverMessage()})})});f.chat.onMessageToOperator(function(a){a.message.__SPI_deferMessageDelivery(function(d){c.processMessageFromVisitor({text:a.message.body},function(b){b.translatedText!=a.message.body&&a.message.updateBody(a.message.body+" ("+b.translatedText+")");d.deliverMessage()})})})})()}});
