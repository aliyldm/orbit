package net.bigpoint.darkorbit.managers.keyboardManager.parser
{
   import flash.events.EventDispatcher;
   import flash.ui.Keyboard;
   
   public class KeyboardXmlParser extends EventDispatcher implements IKeyboardParser
   {
      
      public static const NAME:String = "name";
      
      public static const PARAMS:String = "params";
      
      private const KEY:String = "key";
      
      private const CALLBACK:String = "callback";
      
      private const KEYCODE:String = "keycode";
      
      private const KEYVALUEPAIR:String = "keyValuePair";
      
      private const PARAM:String = "param";
      
      private const FUNCTION:String = "function";
      
      private var map:Object;
      
      private var xml:XML;
      
      public function KeyboardXmlParser(param1:XML)
      {
         super();
         this.xml = param1;
      }
      
      private function parseXml(param1:XML) : Object
      {
         var _loc4_:XML = null;
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc2_:Object = new Object();
         var _loc3_:XMLList = param1.child(this.KEYVALUEPAIR);
         for each(_loc4_ in _loc3_)
         {
            for each(_loc5_ in _loc4_.child(this.KEYCODE))
            {
               _loc2_[_loc5_] = this.parseParams(_loc4_.child(this.CALLBACK),_loc2_[_loc5_]);
            }
            for each(_loc6_ in _loc4_.child(this.KEY))
            {
               if(Keyboard[_loc6_.toString()] != undefined && Keyboard[_loc6_.toString()] != null)
               {
                  _loc7_ = Keyboard[_loc6_.toString()];
                  _loc2_[_loc7_] = this.parseParams(_loc4_.child(this.CALLBACK),_loc2_[_loc7_]);
               }
            }
         }
         this.map = _loc2_;
         return _loc2_;
      }
      
      private function parseParams(param1:XMLList, param2:Object) : Vector.<Object>
      {
         var _loc3_:Vector.<Object> = null;
         var _loc4_:XML = null;
         var _loc5_:Object = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:XML = null;
         var _loc8_:XML = null;
         if(param2 == null)
         {
            _loc3_ = new Vector.<Object>();
         }
         else
         {
            _loc3_ = param2 as Vector.<Object>;
         }
         for each(_loc4_ in param1)
         {
            _loc5_ = new Object();
            _loc6_ = new Vector.<String>();
            for each(_loc7_ in _loc4_.child(PARAMS))
            {
               for each(_loc8_ in _loc7_.child(this.PARAM))
               {
                  _loc6_.push(_loc8_);
               }
            }
            if(_loc5_[PARAMS] == undefined)
            {
               _loc5_[PARAMS] = new Object();
            }
            _loc5_[NAME] = _loc4_.child(this.FUNCTION);
            _loc5_[PARAMS][_loc4_.child(this.FUNCTION)] = _loc6_;
            _loc3_.push(_loc5_);
         }
         return _loc3_;
      }
      
      public function parse() : Object
      {
         return this.parseXml(this.xml);
      }
   }
}

