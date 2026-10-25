package net.bigpoint.utils
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   
   public class SWFWheel
   {
      
      private static var _stage:Stage;
      
      private static var _state:int;
      
      public static const VERSION:String = "1.5";
      
      public static const STATE_NATIVE:int = 0;
      
      public static const STATE_IF_NEEDED:int = 1;
      
      public static const STATE_HACKED:int = 2;
      
      public static const EXECUTE_LIBRARY_FUNCTION:String = "SWFWheel.join";
      
      public static const GET_STATE_FUNCTION:String = "SWFWheel.getState";
      
      public static const DEFINE_LIBRARY_FUNCTION:String = "function(){if(window.SWFWheel)return;var win=window,doc=document,nav=navigator;var SWFWheel=window.SWFWheel=function(id){this.setUp(id);if(SWFWheel.browser.msie)this.bind4msie();else this.bind()};SWFWheel.prototype={setUp:function(id){var el=SWFWheel.retrieveObject(id);if(el.nodeName.toLowerCase()==\'embed\'||SWFWheel.browser.safari)el=el.parentNode;this.target=el;this.eventType=SWFWheel.browser.mozilla?\'DOMMouseScroll\':\'mousewheel\'},bind:function(){this.target.addEventListener(this.eventType,function(evt){var target,name,delta=0;if(/XPCNativeWrapper/.test(evt.toString())){var k=evt.target.getAttribute(\'id\')||evt.target.getAttribute(\'name\');if(!k)return;target=SWFWheel.retrieveObject(k)}else{target=evt.target}name=target.nodeName.toLowerCase();if(name!=\'object\'&&name!=\'embed\')return;if(!target.checkBrowserScroll()){evt.preventDefault();evt.returnValue=!1}if(!target.triggerMouseEvent)return;switch(!0){case SWFWheel.browser.mozilla:delta=-evt.detail;break;case SWFWheel.browser.opera:delta=evt.wheelDelta/40;break;default:delta=evt.wheelDelta/80;break}target.triggerMouseEvent(delta,evt.ctrlKey,evt.altKey,evt.shiftKey)},!1)},bind4msie:function(){var _wheel,_unload,target=this.target;_wheel=function(){var evt=win.event,delta=0,name=evt.srcElement.nodeName.toLowerCase();if(name!=\'object\'&&name!=\'embed\')return;if(!target.checkBrowserScroll())evt.returnValue=!1;if(!target.triggerMouseEvent)return;delta=evt.wheelDelta/40;target.triggerMouseEvent(delta,evt.ctrlKey,evt.altKey,evt.shiftKey)};_unload=function(){target.detachEvent(\'onmousewheel\',_wheel);win.detachEvent(\'onunload\',_unload)};target.attachEvent(\'onmousewheel\',_wheel);win.attachEvent(\'onunload\',_unload)}};SWFWheel.browser=(function(){var version=\'0,0,0\';try{try{var axo=new ActiveXObject(\'ShockwaveFlash.ShockwaveFlash.6\');try{axo.AllowScriptAccess=\'always\'}catch(e){version=\'6,0,0\'}}catch(e){}version=new ActiveXObject(\'ShockwaveFlash.ShockwaveFlash\').GetVariable(\'$version\').replace(/D+/g,\',\').match(/^,?(.+),?$/)[1]}catch(e){try{if(nav.mimeTypes[\'application/x-shockwave-flash\'].enabledPlugin){version=(nav.plugins[\'Shockwave Flash 2.0\']||nav.plugins[\'Shockwave Flash\']).description.replace(/D+/g,\',\').match(/^,?(.+),?$/)[1]}}catch(e){}}var versionSplit=version.split(\',\');var pv=[0,0,0];pv[0]=parseInt(versionSplit[0],10);pv[1]=parseInt(versionSplit[1],10);pv[2]=parseInt(versionSplit[2],10);var sUsrAg=nav.userAgent;return{chrome:sUsrAg.indexOf(\'Chrome\')>-1,stainless:sUsrAg.indexOf(\'Stainless\')>-1,safari:sUsrAg.indexOf(\'Safari\')>-1,opera:sUsrAg.indexOf(\'Opera\')>-1||sUsrAg.indexOf(\'OPR\')>-1,msie:sUsrAg.indexOf(\'MSIE\')>-1,mozilla:sUsrAg.indexOf(\'Firefox\')>-1,mac:nav.platform.indexOf(\'Mac\')>-1,playerVersion:pv}})();SWFWheel.join=function(id){var t=setInterval(function(){if(SWFWheel.retrieveObject(id)){clearInterval(t);new SWFWheel(id)}},0)};SWFWheel.getState=function(id){var STATE_HACKED=2,STATE_IF_NEEDED=1,STATE_NATIVE=0,br=SWFWheel.browser,fp=br.playerVersion;if(br.mac){if(fp[0]>=10&&fp[1]>=1){if(br.safari||br.stainless)return STATE_NATIVE;else if(br.chrome)return STATE_IF_NEEDED;else return STATE_HACKED}else{return STATE_HACKED}}if(!(fp[0]>=10&&fp[1]>=1)&&SWFWheel.browser.safari)return STATE_HACKED;var el=SWFWheel.retrieveObject(id),name=el.nodeName.toLowerCase(),wmode=\'\';if(name==\'object\'){var k,param,params=el.getElementsByTagName(\'param\'),len=params.length;for(var i=0;i<len;i++){param=params[i];if(param.parentNode!=el)continue;k=param.getAttribute(\'name\');wmode=param.getAttribute(\'value\')||\'\';if(/wmode/i.test(k))break}}else if(name==\'embed\'){var wmode=el.getAttribute(\'wmode\')||\'\'}if(br.msie){if(/transparent/i.test(wmode))return STATE_HACKED;else if(/opaque/i.test(wmode))return STATE_IF_NEEDED;else return STATE_NATIVE}else{if(/opaque|transparent/i.test(wmode))return STATE_HACKED;else return STATE_NATIVE}};SWFWheel.retrieveObject=function(id){var el=doc.getElementById(id);if(!el){var nodes=doc.getElementsByTagName(\'embed\'),len=nodes.length;for(var i=0;i<len;i++){if(nodes[i].getAttribute(\'name\')==id){el=nodes[i];break}}}return el}}";
      
      private static var _browserScroll:Boolean = true;
      
      public function SWFWheel()
      {
         super();
      }
      
      public static function initialize(param1:Stage) : void
      {
         if(!available || isReady)
         {
            return;
         }
         _stage = param1;
         ExternalInterface.call(DEFINE_LIBRARY_FUNCTION);
         ExternalInterface.call(EXECUTE_LIBRARY_FUNCTION,ExternalInterface.objectID);
         ExternalInterface.addCallback("checkBrowserScroll",checkBrowserScroll);
         _state = ExternalInterface.call(GET_STATE_FUNCTION,ExternalInterface.objectID);
         if(_state == STATE_NATIVE)
         {
            return;
         }
         ExternalInterface.addCallback("triggerMouseEvent",triggerMouseEvent);
      }
      
      public static function get isReady() : Boolean
      {
         return _stage != null;
      }
      
      public static function get available() : Boolean
      {
         var f:Boolean = false;
         if(!ExternalInterface.available)
         {
            return f;
         }
         try
         {
            f = Boolean(ExternalInterface.call("function(){return true;}"));
         }
         catch(e:Error)
         {
         }
         return f;
      }
      
      public static function get state() : int
      {
         return _state;
      }
      
      public static function get browserScroll() : Boolean
      {
         return _browserScroll;
      }
      
      public static function set browserScroll(param1:Boolean) : void
      {
         _browserScroll = param1;
      }
      
      private static function triggerMouseEvent(param1:Number, param2:Boolean, param3:Boolean, param4:Boolean) : void
      {
         var _loc7_:InteractiveObject = null;
         if(_state == STATE_NATIVE)
         {
            return;
         }
         if(_state == STATE_IF_NEEDED && _browserScroll)
         {
            return;
         }
         var _loc5_:Array = _stage.getObjectsUnderPoint(new Point(_stage.mouseX,_stage.mouseY));
         var _loc6_:DisplayObject = _loc5_.pop() as DisplayObject;
         while(_loc6_ != null)
         {
            _loc7_ = _loc6_ as InteractiveObject;
            if(_loc7_)
            {
               break;
            }
            _loc6_ = _loc6_.parent;
         }
         if(!_loc7_)
         {
            return;
         }
         var _loc8_:MouseEvent = new MouseEvent(MouseEvent.MOUSE_WHEEL,true,false,_loc7_.mouseX,_loc7_.mouseY,null,param2,param3,param4,false,int(param1));
         _loc7_.dispatchEvent(_loc8_);
      }
      
      private static function checkBrowserScroll() : Boolean
      {
         return _browserScroll;
      }
   }
}

